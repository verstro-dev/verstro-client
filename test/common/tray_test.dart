import 'dart:io';
import 'dart:ui' as ui;

import 'package:fl_clash/common/tray.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('macOS 菜单栏使用独立的透明模板图标', () {
    if (!Platform.isMacOS) {
      return;
    }

    final icon = Tray().getTryIcon(isStart: false, tunEnable: false);

    expect(icon, 'assets/images/icon/status_macos.png');
  });

  test('macOS 菜单栏模板图标没有不透明底板', () async {
    final data = await rootBundle.load('assets/images/icon/status_macos.png');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    final rgba = await frame.image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    final pixels = rgba!.buffer.asUint8List();
    var transparentPixels = 0;
    for (var alphaIndex = 3; alphaIndex < pixels.length; alphaIndex += 4) {
      if (pixels[alphaIndex] == 0) {
        transparentPixels++;
      }
    }

    final pixelCount = frame.image.width * frame.image.height;
    expect(
      transparentPixels,
      greaterThan(pixelCount * 0.6),
      reason: '模板图标的大部分画布应保持全透明，不能再被 macOS 渲染成纯色方块',
    );

    frame.image.dispose();
    codec.dispose();
  });
}
