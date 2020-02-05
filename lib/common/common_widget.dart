import 'package:flutter/material.dart';

//解决InkWell因为child设置了背景而显示不出涟漪的问题
class InkWellButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final List<Widget> children;

  InkWellButton({
    @required this.onTap,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: () {
        this.children.add(
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: this.onTap,
              ),
            ),
          ),
        );
        return this.children;
      }(),
    );
  }
}