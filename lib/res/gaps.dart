import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'dimens.dart';
/// 间隔
class Gaps {
  /// 水平间隔
  static const Widget hGap3 = const SizedBox(width: Dimens.gap_dp3);
  static const Widget hGap4 = const SizedBox(width: Dimens.gap_dp4);
  static const Widget hGap5 = const SizedBox(width: Dimens.gap_dp5);
  static const Widget hGap6 = const SizedBox(width: Dimens.gap_dp6);
  static const Widget hGap10 = const SizedBox(width: Dimens.gap_dp10);
  static const Widget hGap15 = const SizedBox(width: Dimens.gap_dp15);
  static const Widget hGap16 = const SizedBox(width: Dimens.gap_dp16);
  static const Widget hGap20 = const SizedBox(width: Dimens.gap_dp20);
  static const Widget hGap30 = const SizedBox(width: Dimens.gap_dp30);
  /// 垂直间隔
  static const Widget vGap3 = const SizedBox(height: Dimens.gap_dp3);
  static const Widget vGap4 = const SizedBox(height: Dimens.gap_dp4);
  static const Widget vGap5 = const SizedBox(height: Dimens.gap_dp5);
  static const Widget vGap6 = const SizedBox(height: Dimens.gap_dp6);
  static const Widget vGap8 = const SizedBox(height: Dimens.gap_dp8);
  static const Widget vGap10 = const SizedBox(height: Dimens.gap_dp10);
  static const Widget vGap15 = const SizedBox(height: Dimens.gap_dp15);
  static const Widget vGap16 = const SizedBox(height: Dimens.gap_dp16);
  static const Widget vGap20 = const SizedBox(height: Dimens.gap_dp20);
  static const Widget vGap25 = const SizedBox(height: Dimens.gap_dp25);
  static const Widget vGap30 = const SizedBox(height: Dimens.gap_dp30);

  //水平分割线
  static const Widget hLine = const SizedBox(
    height: 0.6,
    width: double.infinity,
    child: const DecoratedBox(decoration: BoxDecoration(color: Colours.divider_color)),
  );

  //垂直分割线
  static const Widget vLine = const SizedBox(
    height: double.infinity,
    width: 0.6,
    child: const DecoratedBox(decoration: BoxDecoration(color: Colours.divider_color)),
  );

  static const Widget empty = const SizedBox();
}