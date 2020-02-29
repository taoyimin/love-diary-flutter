import 'package:flutter/material.dart';
import 'package:love_diary/res/colors.dart';
import 'package:love_diary/res/gaps.dart';

/// 单行选择控件
class SelectRowWidget extends StatelessWidget {
  final String title;
  final String content;
  final double height;
  final GestureTapCallback onTap;

  SelectRowWidget({
    Key key,
    @required this.title,
    @required this.content,
    this.height = 46,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Row(
        children: <Widget>[
          Text(
            '$title',
            style: const TextStyle(fontSize: 15),
          ),
          Gaps.hGap20,
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: onTap,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  content == null || content == '' ? '请选择$title' : content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15,
                    color: content == null || content == ''
                        ? Colours.secondary_text
                        : Colours.primary_text,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 单行文本输入控件
class EditRowWidget extends StatelessWidget {
  final String title;
  final TextStyle style;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  EditRowWidget({
    Key key,
    @required this.title,
    this.style = const TextStyle(fontSize: 15),
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '$title',
            style: style,
          ),
          Gaps.hGap20,
          Flexible(
            child: TextField(
              textAlign: TextAlign.right,
              style: style,
              keyboardType: keyboardType,
              onChanged: onChanged,
              controller: controller,
              decoration: InputDecoration(
                hintText: '请输入$title',
                hintStyle: style,
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//多行文本输入控件
class TextAreaWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final GestureTapCallback onTap;
  final int maxLines;

  TextAreaWidget({
    Key key,
    this.title,
    this.hintText = '请输入',
    this.controller,
    this.onChanged,
    this.onTap,
    this.maxLines = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title != null
            ? Container(
          height: 46,
          child: Row(
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        )
            : Gaps.empty,
        Container(
          child: TextField(
            onTap: onTap ?? () {},
            controller: controller,
            onChanged: onChanged,
            textAlign: TextAlign.start,
            maxLines: maxLines,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 0, bottom: 16),
              hintText: '$hintText',
              hintStyle: TextStyle(fontSize: 15),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        )
      ],
    );
  }
}

//自定义裁剪按钮
class ClipButton extends StatelessWidget {
  final double height;
  final String text;
  final IconData icon;
  final Color color;
  final GestureTapCallback onTap;

  ClipButton({
    this.height = 46,
    @required this.text,
    @required this.icon,
    @required this.onTap,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: RaisedButton(
        padding: const EdgeInsets.all(0),
        color: Colors.white,
        onPressed: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            Expanded(
              child: ClipPath(
                clipper: TipClipper(),
                child: Container(
                  height: height,
                  color: color,
                  child: Center(
                    child: Text(
                      '$text',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//自定义尖头裁剪器
class TipClipper extends CustomClipper<Path> {
  double clipHeightRatio; //裁剪的尖头高度占控件总高度的比率
  double clipWidthRatio; //裁剪的尖头宽度占控件总高度的比率

  TipClipper({this.clipHeightRatio = 0.5, this.clipWidthRatio = 0.25});

  @override
  Path getClip(Size size) {
    double clipHeight = size.height * clipHeightRatio;
    double clipWidth = size.height * clipWidthRatio;
    double leftHeight = size.height * (1 - clipHeightRatio) / 2;

    final path = Path();
    path.lineTo(0, leftHeight);
    path.conicTo(clipWidth / 4, leftHeight + clipHeight * 3 / 8, clipWidth,
        size.height / 2, 1);
    path.conicTo(clipWidth / 4, leftHeight + clipHeight * 5 / 8, 0,
        clipHeight + leftHeight, 1);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TipClipper oldClipper) => false;
}