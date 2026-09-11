import 'package:dio/dio.dart';
import 'package:fl_clash/verstro/api/api_exceptions.dart';
import 'package:flutter/widgets.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_clash/verstro/api/backend_api.dart';
import 'package:fl_clash/verstro/api/token_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final mode in ['automatic', 'independent']) {
    test('真实BackendApi普通POST明确序列化$mode意图', () async {
      SharedPreferences.setMockInitialValues({
        'verstro_jwt_v1': 'synthetic-token',
      });
      await AppLocalizations.load(const Locale('en'));
      final requests = <RequestOptions>[];
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              requests.add(request);
              handler.resolve(
                Response(
                  requestOptions: request,
                  statusCode: 201,
                  data: {
                    'id': 7,
                    'plan_id': 'monthly',
                    'base_price': '6.00',
                    'final_amount': '6.01',
                    'status': 'waiting',
                    'deposit_address': 'test',
                    'pay_currency': 'usdttrc20',
                    'created_at': '2026-09-09T00:00:00Z',
                    'expires_at': '2026-09-10T00:00:00Z',
                  },
                ),
              );
            },
          ),
        );
      final api = BackendApi(
        baseUrl: 'https://example.test',
        token: TokenStorage(await SharedPreferences.getInstance()),
        dio: dio,
      );
      if (mode == 'automatic') {
        await api.createOrder(
          'monthly',
          expectedPlanVersionId: 1,
          expectedBasePriceCents: 600,
        );
      } else {
        await api.createOrder(
          'monthly',
          purchaseMode: mode,
          expectedPlanVersionId: 1,
          expectedBasePriceCents: 600,
        );
      }
      expect(requests.single.path, '/v1/orders');
      expect(requests.single.data['purchase_mode'], mode);
    });
  }
  for (final code in [
    'entitlement_upgrade_required',
    'purchase_entitlements_unverified',
    'invalid_json',
  ]) {
    test('真实HTTP错误$code不删除mode或自动重试', () async {
      SharedPreferences.setMockInitialValues({
        'verstro_jwt_v1': 'synthetic-token',
      });
      await AppLocalizations.load(const Locale('en'));
      final requests = <RequestOptions>[];
      final dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              requests.add(request);
              handler.resolve(
                Response(
                  requestOptions: request,
                  statusCode: code == 'invalid_json' ? 400 : 409,
                  data: {'code': code, 'message': '服务端要求重新确认'},
                ),
              );
            },
          ),
        );
      final api = BackendApi(
        baseUrl: 'https://example.test',
        token: TokenStorage(await SharedPreferences.getInstance()),
        dio: dio,
      );
      await expectLater(
        api.createOrder(
          'monthly',
          expectedPlanVersionId: 1,
          expectedBasePriceCents: 600,
        ),
        throwsA(isA<BackendException>()),
      );
      expect(requests, hasLength(1));
      expect(requests.single.data['purchase_mode'], 'automatic');
    });
  }
}
