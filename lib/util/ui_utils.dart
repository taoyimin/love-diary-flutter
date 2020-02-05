import 'dart:math';

import 'package:flutter/material.dart';

/// UI工具类
///
/// 用于获取通用样式，通用widget不放在这里，放在common包中
/// 自定义widget不放在这里，放在widget包中
class UIUtils {
  /// 获取默认的阴影
  static BoxShadow getBoxShadow() {
    return const BoxShadow(
      offset: const Offset(0, 12),
      color: const Color(0xFFDFDFDF),
      blurRadius: 25,
      spreadRadius: -9,
    );
  }

  /// 获取随机颜色
  static Color getRandomColor() {
    return Color.fromARGB(255, Random.secure().nextInt(255),
        Random.secure().nextInt(255), Random.secure().nextInt(255));
  }
}
