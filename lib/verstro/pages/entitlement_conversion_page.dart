import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../providers/auth_provider.dart';
import '../providers/account_refresh.dart';
import 'usdt_invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/common/app_localizations.dart';
import '../api/account_entitlement_models.dart';
import '../providers/backend_api_provider.dart';
import '../util/plan_display.dart';
import '../widgets/account_entitlements_card.dart';

/// 仅使用服务端具名换购资源；普通购买仍为独立显式入口。
class EntitlementConversionPage extends ConsumerStatefulWidget {
  const EntitlementConversionPage({
    super.key,
    this.conversionId,
    this.initialTargetTier,
    this.initialCouponCode,
    this.initialUseCredit = true,
    this.intentOwnerId,
  });
  final String? initialTargetTier, initialCouponCode;
  final bool initialUseCredit;
  final int? intentOwnerId;
  final String? conversionId;
  @override
  ConsumerState<EntitlementConversionPage> createState() =>
      _EntitlementConversionPageState();
}

class _EntitlementConversionPageState
    extends ConsumerState<EntitlementConversionPage> {
  final _coupon = TextEditingController();
  String _tier = 'premium';
  bool _credit = true, _busy = false, _failed = false, _dirty = false;
  int _generation = 0, _recoverFromOrderId = 0;
  List<Map<String, dynamic>> _recoverablePayments = const [];
  int? _userId;
  String? _resourceId;
  Map<String, dynamic>? _attempt;
  Map<String, dynamic>? _acceptedRequest;
  String? _acceptedQuoteToken;
  EntitlementConversion? _resource;
  EntitlementConversionQuote? _quote;
  Timer? _poll;
  Map<String, dynamic> get _request => {
    'target_tier': _tier,
    'use_credit': _credit,
    if (_recoverFromOrderId > 0) 'recover_from_order_id': _recoverFromOrderId,
    if (_coupon.text.trim().isNotEmpty) 'coupon_code': _coupon.text.trim(),
  };
  String _storageKey(int uid) => 'verstro_conversion_attempt_v1_$uid';
  bool _valid(int uid, int generation) {
    if (!mounted || uid != _userId || generation != _generation) return false;
    final auth = ref.read(authNotifierProvider);
    return !auth.isLoading && !auth.hasError && auth.value?.user?.id == uid;
  }

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted &&
          !_busy &&
          _resourceId != null &&
          _resource?.isTerminal != true) {
        _action('refresh');
      } else if (mounted &&
          !_busy &&
          _quote != null &&
          !_quote!.expiresAt.isAfter(DateTime.now())) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _coupon.dispose();
    super.dispose();
  }

  Future<void> _restore(int uid, int generation) async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      if (!_valid(uid, generation)) return;
      final encoded = prefs.getString(_storageKey(uid));
      Map<String, dynamic>? saved;
      try {
        if (encoded != null) {
          saved = jsonDecode(encoded) as Map<String, dynamic>;
        }
      } catch (_) {
        if (widget.conversionId == null) rethrow;
      }
      _resourceId = widget.conversionId;
      _dirty = _resourceId != null;
      if (saved != null &&
          (widget.conversionId == null || saved['id'] == widget.conversionId)) {
        _resourceId = saved['id'] as String?;
        if (_resourceId == null) {
          _attempt = saved;
          _quote = EntitlementConversionQuote.fromJson(
            saved['quote'] as Map<String, dynamic>,
          );
        }
        if (saved['request'] is Map) {
          final request = saved['request'] as Map;
          _tier = request['target_tier'] as String? ?? 'premium';
          _credit = request['use_credit'] == true;
          _recoverFromOrderId = request['recover_from_order_id'] as int? ?? 0;
          _coupon.text = request['coupon_code'] as String? ?? '';
        }
        _acceptedRequest = saved['accepted_request'] is Map
            ? Map<String, dynamic>.from(saved['accepted_request'] as Map)
            : null;
        _acceptedQuoteToken = saved['accepted_quote_token'] as String?;
        _dirty =
            _resourceId != null &&
            (saved['dirty'] != false ||
                _acceptedRequest == null ||
                _acceptedQuoteToken == null ||
                !mapEquals(_acceptedRequest, _request));
      }
      // 新购买意图只初始化空入口；已有未知创建或具名资源必须先按原请求恢复。
      var newIntent =
          saved == null &&
          _resourceId == null &&
          widget.intentOwnerId == uid &&
          widget.initialTargetTier != null;
      if (newIntent) {
        _tier = widget.initialTargetTier ?? 'premium';
        _coupon.text = widget.initialCouponCode ?? '';
        _credit = widget.initialUseCredit;
      }
      if (_resourceId != null) {
        final api = await ref.read(backendApiProvider.future);
        if (!_valid(uid, generation)) return;
        final resource = await api.getEntitlementConversion(_resourceId!);
        if (!_valid(uid, generation)) return;
        if (resource.id != _resourceId) {
          throw const FormatException('conversion identity mismatch');
        }
        _resource = resource;
        _quote = resource.quote;
        if (_acceptedQuoteToken != resource.quote.quoteToken) _dirty = true;
        // 普通升级入口不继续绑定已关闭的旧意图；具名历史入口仍保留原交易。
        // 只有服务端明确确认终态才清本账号草稿，读取失败或结果未知绝不重下单。
        if (resource.isTerminal && widget.conversionId == null) {
          if (prefs.getString(_storageKey(uid)) != encoded ||
              !await prefs.remove(_storageKey(uid))) {
            throw StateError('conversion draft changed');
          }
          if (!_valid(uid, generation)) return;
          _resetPreview();
          newIntent =
              widget.intentOwnerId == uid && widget.initialTargetTier != null;
          if (newIntent) {
            _tier = widget.initialTargetTier!;
            _coupon.text = widget.initialCouponCode ?? '';
            _credit = widget.initialUseCredit;
          }
        }
      }
      if (_valid(uid, generation)) {
        setState(() => _busy = false);
        if (newIntent) await _load();
      }
    } catch (_) {
      if (_valid(uid, generation)) {
        setState(() {
          _failed = true;
          _busy = false;
        });
      }
    }
  }

  Map<String, dynamic> _savedDraft(
    String id, {
    Map<String, dynamic>? accepted,
    String? token,
    bool? dirty,
  }) => {
    'id': id,
    'request': _request,
    'accepted_request': accepted ?? _acceptedRequest,
    'accepted_quote_token': token ?? _acceptedQuoteToken,
    'dirty': dirty ?? _dirty,
  };
  void _editResource() {
    setState(() {
      _dirty = true;
      _generation++;
    });
    final uid = _userId;
    final id = _resourceId;
    final generation = _generation;
    if (uid == null || id == null) return;
    final snapshot = jsonEncode(_savedDraft(id));
    unawaited(() async {
      try {
        final prefs = await ref.read(sharedPreferencesProvider.future);
        if (!_valid(uid, generation)) return;
        if (!await prefs.setString(_storageKey(uid), snapshot)) {
          throw StateError('cannot persist draft');
        }
      } catch (_) {
        if (_valid(uid, generation)) setState(() => _failed = true);
      }
    }());
  }

  void _changed() {
    setState(() {
      _generation++;
      _quote = null;
      _failed = false;
      _busy = false;
    });
  }

  Future<void> _load() async {
    final uid = _userId;
    if (uid == null || _busy || _attempt != null || _resourceId != null) return;
    final generation = ++_generation;
    final request = _request;
    setState(() {
      _busy = true;
      _failed = false;
      _quote = null;
    });
    try {
      final api = await ref.read(backendApiProvider.future);
      if (!_valid(uid, generation)) return;
      final quote = await api.quoteEntitlementConversion(
        targetTier: request['target_tier'] as String,
        couponCode: request['coupon_code'] as String?,
        useCredit: request['use_credit'] as bool,
        recoverFromOrderId: request['recover_from_order_id'] as int? ?? 0,
      );
      if (_valid(uid, generation)) {
        setState(() {
          _quote = quote;
          _recoverablePayments = quote.recoverablePayments;
          _busy = false;
        });
      }
    } catch (_) {
      if (_valid(uid, generation)) {
        setState(() {
          _failed = true;
          _busy = false;
        });
      }
    }
  }

  Future<void> _action(String action) async {
    final uid = _userId;
    if (uid == null || _busy) return;
    final generation = ++_generation;
    final resource = _resource;
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final api = await ref.read(backendApiProvider.future);
      if (!_valid(uid, generation)) return;
      late EntitlementConversion result;
      if (action == 'create') {
        final quote = _quote;
        if (_attempt == null) {
          if (quote == null ||
              !quote.capability.executeSupported ||
              quote.target == null ||
              !quote.expiresAt.isAfter(DateTime.now())) {
            throw const FormatException('unavailable quote');
          }
          final random = Random.secure();
          _attempt = {
            'key': base64UrlEncode(
              List<int>.generate(24, (_) => random.nextInt(256)),
            ),
            'request': _request,
            'quote': quote.toJson(),
          };
        }
        // 每次发送都先确认可持久保存，相同逻辑动作保留同一幂等键。
        if (!await prefs.setString(_storageKey(uid), jsonEncode(_attempt))) {
          throw StateError('cannot persist conversion request');
        }
        if (!_valid(uid, generation)) return;
        result = await api.createEntitlementConversion(
          request: _attempt!['request'] as Map<String, dynamic>,
          quote: EntitlementConversionQuote.fromJson(
            _attempt!['quote'] as Map<String, dynamic>,
          ),
          idempotencyKey: _attempt!['key'] as String,
        );
      } else if (action == 'requote') {
        result = await api.requoteEntitlementConversion(
          _resourceId!,
          request: Map<String, dynamic>.from(_request)
            ..remove('recover_from_order_id'),
        );
      } else if (action == 'confirm') {
        if (resource == null ||
            !resource.canConfirm ||
            _dirty ||
            _acceptedRequest == null ||
            _acceptedQuoteToken != resource.quote.quoteToken ||
            !mapEquals(_acceptedRequest, _request) ||
            !resource.quote.expiresAt.isAfter(DateTime.now())) {
          throw const FormatException('unavailable confirmation');
        }
        result = await api.confirmEntitlementConversion(
          resource.id,
          revision: resource.revision,
          quoteToken: resource.quote.quoteToken,
        );
      } else if (action == 'cancel') {
        if (resource == null || !resource.canCancel) {
          throw const FormatException('unavailable cancellation');
        }
        result = await api.cancelEntitlementConversion(
          resource.id,
          revision: resource.revision,
        );
      } else {
        result = await api.getEntitlementConversion(_resourceId!);
      }
      if (!_valid(uid, generation)) return;
      if (_resourceId != null && result.id != _resourceId) {
        throw const FormatException('conversion identity mismatch');
      }
      final accepted = action == 'refresh'
          ? _acceptedRequest
          : Map<String, dynamic>.from(_request);
      final token = action == 'refresh'
          ? _acceptedQuoteToken
          : result.quote.quoteToken;
      final dirty = action == 'refresh'
          ? (_dirty || token != result.quote.quoteToken)
          : false;
      if (!await prefs.setString(
        _storageKey(uid),
        jsonEncode(
          _savedDraft(
            result.id,
            accepted: accepted,
            token: token,
            dirty: dirty,
          ),
        ),
      )) {
        throw StateError('cannot persist conversion binding');
      }
      if (!_valid(uid, generation)) return;
      if (_resourceId != null && result.id != _resourceId) {
        throw const FormatException('conversion identity mismatch');
      }
      setState(() {
        _dirty = dirty;
        _acceptedRequest = accepted;
        _acceptedQuoteToken = token;
        _resource = result;
        _resourceId = result.id;
        _quote = result.quote;
        _attempt = null;
        _busy = false;
      });
      if (action != 'refresh') invalidateAccount(ref.invalidate);
    } catch (_) {
      if (!_valid(uid, generation)) return;
      // 任何写错误都可能是提交后响应丢失；仅查询，不自动再次确认或另建单。
      if (_resourceId != null) {
        try {
          final api = await ref.read(backendApiProvider.future);
          if (!_valid(uid, generation)) return;
          final fresh = await api.getEntitlementConversion(_resourceId!);
          if (_valid(uid, generation)) {
            if (fresh.id != _resourceId) {
              throw const FormatException('conversion identity mismatch');
            }
            _resource = fresh;
            _quote = fresh.quote;
            if (_acceptedQuoteToken != fresh.quote.quoteToken) _dirty = true;
          }
        } catch (_) {
          /* 保留最后确认的服务端资源，错误不当作零权益。 */
        }
      }
      if (_valid(uid, generation)) {
        setState(() {
          _failed = true;
          _busy = false;
        });
      }
    }
  }

  Future<void> _openPayment() async {
    final uid = _userId, oid = _resource?.paymentOrderId;
    if (uid == null || oid == null || _busy) return;
    final generation = _generation;
    setState(() => _busy = true);
    try {
      final api = await ref.read(backendApiProvider.future);
      if (!_valid(uid, generation)) return;
      final order = await api.getOrder(oid);
      if (!_valid(uid, generation)) return;
      if (order.id != oid ||
          !order.isConversion ||
          order.conversionId != _resourceId) {
        throw const FormatException('wrong conversion payment');
      }
      setState(() => _busy = false);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              VerstroUsdtInvoicePage(order: order, conversionPayment: true),
        ),
      );
      if (_valid(uid, generation)) {
        invalidateAccount(ref.invalidate);
        await _action('refresh');
      }
    } catch (_) {
      if (_valid(uid, generation)) {
        setState(() {
          _busy = false;
          _failed = true;
        });
      }
    }
  }

  Future<void> _newPreview() async {
    final uid = _userId;
    if (uid == null || _busy || _resource?.isTerminal != true) return;
    final generation = ++_generation;
    setState(() => _busy = true);
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      if (!_valid(uid, generation)) return;
      final encoded = prefs.getString(_storageKey(uid));
      // 从历史订单进入时不能删除另一笔尚未完成的意图。
      if (encoded != null) {
        final saved = jsonDecode(encoded) as Map<String, dynamic>;
        if (saved['id'] != _resourceId ||
            !await prefs.remove(_storageKey(uid))) {
          throw StateError('another conversion draft exists');
        }
      }
      if (!_valid(uid, generation)) return;
      setState(_resetPreview);
    } catch (_) {
      if (_valid(uid, generation)) setState(() => _failed = true);
    } finally {
      if (_valid(uid, generation)) setState(() => _busy = false);
    }
  }

  void _resetPreview() {
    _recoverFromOrderId = 0;
    _recoverablePayments = const [];
    _resource = null;
    _resourceId = null;
    _quote = null;
    _attempt = null;
    _acceptedRequest = null;
    _acceptedQuoteToken = null;
    _dirty = false;
    _failed = false;
  }

  String _statusLabel(String status) => switch (status) {
    'awaiting_payment' => appLocalizations.vConvAwaiting,
    'reconfirm_required' => appLocalizations.vConvReconfirm,
    'settling' => appLocalizations.vConvSettling,
    'pending_sync' => appLocalizations.vConvSync,
    'completed' => appLocalizations.vConvCompleted,
    'cancelled' => appLocalizations.vConvCancelled,
    'expired' => appLocalizations.vConvExpired,
    _ => appLocalizations.vConvRecovery,
  };

  String _money(dynamic value) =>
      '${((value as num? ?? 0) / 100).toStringAsFixed(2)} USDT';
  String _duration(dynamic seconds) {
    final n = seconds as int? ?? 0;
    return '${n ~/ 86400} d ${(n % 86400) ~/ 3600} h';
  }

  Widget _amount(String label, dynamic cents) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Text(_money(cents)),
      ],
    ),
  );
  String _exclusion(String reason) {
    if (reason.isEmpty) return '';
    final label = switch (reason) {
      'refund_or_adjustment' ||
      'entitlement_adjusted' => appLocalizations.vEntExcludedAdjusted,
      'not_lower_tier' => appLocalizations.vEntExcludedTier,
      'not_convertible_state' => appLocalizations.vEntExcludedState,
      'trial' ||
      'non_cash_funding' ||
      'non_cash_card' => appLocalizations.vEntExcludedTrial,
      'no_remaining_value' => appLocalizations.vEntExcludedEmpty,
      'unpaid_card' => appLocalizations.vEntExcludedUnpaid,
      _ => appLocalizations.vEntExcludedUnknown,
    };
    return '$label ($reason)';
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final uid = !auth.isLoading && !auth.hasError ? auth.value?.user?.id : null;
    if (uid != _userId) {
      _generation++;
      _userId = uid;
      _quote = null;
      _resource = null;
      _resourceId = widget.conversionId;
      _attempt = null;
      _failed = false;
      _busy = uid != null;
      _dirty = false;
      _coupon.clear();
      _credit = true;
      _recoverFromOrderId = 0;
      _recoverablePayments = const [];
      if (uid != null) {
        final generation = _generation;
        Future.microtask(() => _restore(uid, generation));
      }
    }
    final quote = _quote, resource = _resource;
    final inputsEnabled =
        !_busy &&
        _attempt == null &&
        (resource == null ? _resourceId == null : resource.canRequote);
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(title: Text(appLocalizations.vEntUpgrade)),
        body: Center(child: Text(appLocalizations.vConvLogin)),
      );
    }
    return PopScope<Object?>(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) invalidateAccount(ref.invalidate);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(appLocalizations.vEntUpgrade)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _tier,
              decoration: InputDecoration(
                labelText: appLocalizations.vEntTarget,
              ),
              items: ['premium']
                  .map(
                    (tier) => DropdownMenuItem(
                      value: tier,
                      child: Text(
                        localizedPlanName(
                          tier == 'premium' ? 'premium-monthly' : 'monthly',
                          tier,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: !inputsEnabled
                  ? null
                  : (value) {
                      if (value != null) {
                        _tier = value;
                        _changed();
                      }
                    },
            ),
            TextField(
              controller: _coupon,
              enabled: inputsEnabled,
              decoration: InputDecoration(
                labelText: appLocalizations.vPayCouponDiscountLabel,
              ),
              onChanged: (_) {
                if (resource == null) {
                  _changed();
                } else {
                  _editResource();
                }
              },
            ),
            SwitchListTile(
              title: Text(appLocalizations.vEntCredit),
              value: _credit,
              onChanged: !inputsEnabled
                  ? null
                  : (value) {
                      setState(() => _credit = value);
                      if (resource == null) {
                        _changed();
                      } else {
                        _editResource();
                      }
                    },
            ),
            if (_resourceId == null &&
                _attempt == null &&
                (_recoverablePayments.isNotEmpty ||
                    _recoverFromOrderId > 0)) ...[
              DropdownButtonFormField<int>(
                key: const ValueKey('conversion-recovery'),
                initialValue: _recoverFromOrderId,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: appLocalizations.vConvRecoverySource,
                ),
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(appLocalizations.vConvRecoveryNone),
                  ),
                  for (final payment in _recoverablePayments)
                    DropdownMenuItem(
                      value: payment['order_id'] as int,
                      child: Text(
                        '#${payment['order_id']} · ${_money(payment['available_cents'])}',
                      ),
                    ),
                  if (_recoverFromOrderId > 0 &&
                      !_recoverablePayments.any(
                        (p) => p['order_id'] == _recoverFromOrderId,
                      ))
                    DropdownMenuItem(
                      value: _recoverFromOrderId,
                      child: Text('#$_recoverFromOrderId'),
                    ),
                ],
                onChanged: !inputsEnabled
                    ? null
                    : (value) {
                        if (value == null || value == _recoverFromOrderId) {
                          return;
                        }
                        _recoverFromOrderId = value;
                        _changed();
                      },
              ),
              Text(appLocalizations.vConvRecoveryHint),
            ],
            if (_resourceId == null && _attempt == null)
              FilledButton(
                key: const ValueKey('conversion-quote'),
                onPressed: _busy ? null : _load,
                child: Text(appLocalizations.vEntQuote),
              ),
            if (_busy) const LinearProgressIndicator(),
            if (_failed)
              Text(
                _resourceId != null || _attempt != null
                    ? appLocalizations.vConvUnknown
                    : appLocalizations.vEntQuoteError,
              ),
            if (_resourceId != null) ...[
              Text('${appLocalizations.vConvIdentity}: $_resourceId'),
              if (resource != null) Text(_statusLabel(resource.status)),
              if (resource?.isTerminal == true)
                FilledButton(
                  key: const ValueKey('conversion-new-preview'),
                  onPressed: _busy ? null : _newPreview,
                  child: Text(appLocalizations.vConvNew),
                ),
              OutlinedButton(
                key: const ValueKey('conversion-refresh'),
                onPressed: _busy ? null : () => _action('refresh'),
                child: Text(appLocalizations.vConvRefresh),
              ),
            ],
            if (quote != null) ...[
              Text(
                '${appLocalizations.vEntAsOf}: ${entitlementDate(quote.asOf)} / ${entitlementDate(quote.expiresAt)}',
              ),
              const SizedBox(height: 12),
              if (_resourceId == null && !quote.capability.executeSupported)
                Text(
                  '${quote.capability.reason == 'conversion_admission_closed' ? appLocalizations.vEntAdmissionClosed : appLocalizations.vEntUnsupported} (${quote.capability.reason})',
                ),
              Text(appLocalizations.vEntCompareHint),
              Text(
                '${appLocalizations.vEntBefore}: ${_duration(quote.before['remaining_seconds'])} / ${entitlementBytes(quote.before['remaining_bytes'] as int? ?? 0)}',
              ),
              if (quote.target == null) ...[
                Text(
                  quote.recommendationReason == 'no_eligible_sources'
                      ? appLocalizations.vEntNoEligible
                      : quote.recommendationReason == 'no_available_plans'
                      ? appLocalizations.vEntNoAvailable
                      : appLocalizations.vEntNoTarget,
                ),
                Text(appLocalizations.vEntRetained),
              ] else ...[
                Text(
                  localizedPlanName(
                    quote.target!['plan_id'] as String,
                    quote.target!['plan_id'] as String,
                  ),
                ),
                Text(
                  'SKU: ${quote.target!['plan_id']} · version: ${quote.target!['plan_version_id']} · × ${quote.target!['quantity']}',
                ),
                Text(
                  '${appLocalizations.vEntAfter}: ${quote.target!['duration_days']} d / ${entitlementBytes(quote.target!['traffic_bytes'] as int)}',
                ),
                Text(
                  quote.after['activation'] == 'queued'
                      ? appLocalizations.vEntIfQueued
                      : appLocalizations.vEntIfImmediate,
                ),
                _amount(
                  appLocalizations.vEntOriginal,
                  quote.target!['base_price_cents'],
                ),
                _amount(
                  appLocalizations.vEntDiscount,
                  quote.target!['discount_cents'],
                ),
                _amount(
                  appLocalizations.vEntNet,
                  quote.target!['price_after_discount_cents'],
                ),
              ],
              _amount(
                appLocalizations.vEntValue,
                quote.amounts['conversion_value_cents'],
              ),
              _amount(
                appLocalizations.vConvCarry,
                quote.amounts['carried_funding_cents'] ?? 0,
              ),
              if ((quote.amounts['carried_funding_cents'] as int? ?? 0) > 0)
                Text(
                  '${appLocalizations.vConvCarry}: #${quote.amounts['carried_from_order_id']}',
                ),
              _amount(
                appLocalizations.vEntCreditApplied,
                quote.amounts['account_credit_cents'],
              ),
              if (quote.target != null)
                _amount(appLocalizations.vEntDue, quote.amounts['due_cents']),
              const Divider(),
              Text(
                appLocalizations.vEntSources,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              for (final source in quote.sources)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '#${source['entitlement_id']} · ${localizedPlanName(source['plan_id'] as String, source['plan_id'] as String)}',
                      ),
                      Text(
                        '${appLocalizations.vEntSource}: ${source['source_kind'] == 'card'
                            ? appLocalizations.vEntCard
                            : source['source_kind'] == 'order'
                            ? appLocalizations.vEntOrder
                            : source['source_kind']} ${source['source_id']}',
                      ),
                      Text(
                        '${source['eligible'] == true ? appLocalizations.vEntEligible : appLocalizations.vEntExcluded}: ${_exclusion(source['exclusion_reason'] as String? ?? '')}',
                      ),
                      Text(
                        '${appLocalizations.vEntApproxValue}: ${source['residual_value_usdt_display'] ?? '—'} USDT',
                      ),
                      ExpansionTile(
                        title: Text(appLocalizations.vEntDetails),
                        children: [
                          _amount(
                            appLocalizations.vEntPurchaseValue,
                            source['purchase_value_cents'],
                          ),
                          Text(
                            '${appLocalizations.vEntDuration}: ${_duration(source['remaining_seconds'])} / ${_duration(source['total_seconds'])}',
                          ),
                          Text(
                            '${appLocalizations.vEntTraffic}: ${entitlementBytes(source['remaining_bytes'] as int? ?? 0)} / ${entitlementBytes(source['total_bytes'] as int? ?? 0)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Text(appLocalizations.vConvEndHint),
              if (_resourceId == null &&
                  (quote.capability.executeSupported && quote.target != null ||
                      _attempt != null))
                FilledButton(
                  key: const ValueKey('conversion-create'),
                  onPressed:
                      _busy ||
                          (_attempt == null &&
                              !quote.expiresAt.isAfter(DateTime.now()))
                      ? null
                      : () => _action('create'),
                  child: Text(
                    _attempt == null
                        ? appLocalizations.vConvCreate
                        : appLocalizations.vConvRetryCreate,
                  ),
                ),
              if (!quote.expiresAt.isAfter(DateTime.now()) &&
                  resource?.isTerminal != true)
                Text(appLocalizations.vConvQuoteExpired),
              if (resource?.canRequote == true)
                OutlinedButton(
                  key: const ValueKey('conversion-requote'),
                  onPressed: _busy ? null : () => _action('requote'),
                  child: Text(appLocalizations.vConvRequote),
                ),
              if (resource?.canConfirm == true)
                FilledButton(
                  key: const ValueKey('conversion-confirm'),
                  onPressed:
                      _busy ||
                          _dirty ||
                          !quote.expiresAt.isAfter(DateTime.now())
                      ? null
                      : () => _action('confirm'),
                  child: Text(
                    resource!.reason == 'quote_acceptance_required'
                        ? appLocalizations.vConvAcceptQuote
                        : appLocalizations.vConvConfirm,
                  ),
                ),
              if (resource?.paymentOrderId != null &&
                  const {
                    'awaiting_payment',
                    'reconfirm_required',
                    'expired',
                    'cancelled',
                  }.contains(resource?.status))
                OutlinedButton(
                  key: const ValueKey('conversion-payment'),
                  onPressed: _busy ? null : _openPayment,
                  child: Text(appLocalizations.vConvOpenPayment),
                ),
              if (resource?.canCancel == true)
                TextButton(
                  key: const ValueKey('conversion-cancel'),
                  onPressed: _busy ? null : () => _action('cancel'),
                  child: Text(appLocalizations.vConvCancel),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
