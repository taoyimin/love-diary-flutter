import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

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

  /// 获取下拉刷新header
  static ClassicalHeader getRefreshClassicalHeader() {
    return ClassicalHeader(
      refreshText: "用力拉我 ╰(*°▽°*)╯",
      refreshReadyText: "把我松开  (*/ω＼*)",
      refreshingText: "努力加载 （ ￣ー￣）",
      refreshedText: "成功了 o(*≧▽≦)ツ",
      refreshFailedText: "刷新失败",
      noMoreText: "没有更多数据",
      infoText: "更新于 %T",
    );
  }

  /// 获取上拉加载footer
  static ClassicalFooter getLoadClassicalFooter() {
    return ClassicalFooter(
      loadText: "用力拉我 ╰(*°▽°*)╯",
      loadReadyText: "把我松开  (*/ω＼*)",
      loadingText: "努力加载 （ ￣ー￣）",
      loadedText: "成功了 o(*≧▽≦)ツ",
      loadFailedText: "加载失败",
      noMoreText: "真的没有啦  (´ • _ •  ` )",
      infoText: "更新于 %T",
    );
  }
}
