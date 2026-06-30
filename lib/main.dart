import 'dart:async';
import 'dart:io';

import 'package:fl_clash/pages/error.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/verstro/verstro_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application.dart';
import 'common/common.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final version = await system.version;
    final container = await globalState.init(version);
    HttpOverrides.global = FlClashHttpOverrides();
    runApp(
      UncontrolledProviderScope(
        container: container,
        // VerstroGate 强制 Verstro auth + 有效订阅, 通过后才渲染 FlClash Application.
        // 阶段 2.3.6 集成. 未登录 → Verstro Login/Register/Forgot/Reset;
        // 已登录无订阅 → Verstro PlanPicker (强制购买);
        // 已登录有效订阅 → Application (Application.initState 内 verstroAutoIntegrate
        // 自动 import 订阅 URL + 设默认 TUN.enable=true + mode=Mode.global).
        child: const VerstroGate(child: Application()),
      ),
    );
  } catch (e, s) {
    return runApp(
      MaterialApp(
        home: InitErrorScreen(error: e, stack: s),
      ),
    );
  }
}
