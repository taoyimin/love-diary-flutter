import 'dart:io';
import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:love_diary/bean/diary.dart';
import 'package:love_diary/res/gaps.dart';
import 'package:love_diary/util/file_utils.dart';
import 'package:love_diary/util/system_utils.dart';
import 'package:love_diary/util/toast_utils.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';

import 'common/common_widget.dart';

class AddDiaryPage extends StatefulWidget {
  final Diary diary;
  final int type; //0:新增 1:修改

  AddDiaryPage({this.diary, this.type = 0});

  @override
  _AddDiaryPageState createState() => _AddDiaryPageState();
}

class _AddDiaryPageState extends State<AddDiaryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DiaryProvider provider = DiaryProvider();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController festivalController = TextEditingController();
  final TextEditingController achievementController = TextEditingController();
  Diary diary;
  List<Asset> assetList;

  @override
  void initState() {
    super.initState();
    diary = widget.diary ?? Diary();
    contentController.text = diary.content;
    festivalController.text = diary.festival;
    achievementController.text = diary.achievement;
  }

  @override
  void dispose() {
    contentController.dispose();
    festivalController.dispose();
    achievementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(() {
          if (widget.type == 0) {
            return '添加回忆';
          } else if (widget.type == 1) {
            return '修改回忆';
          } else {
            return '未知类型type=${widget.type}';
          }
        }()),
        backgroundColor: Colors.pinkAccent,
        actions: <Widget>[
          Offstage(
            offstage: widget.type != 1,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("删除回忆"),
                      content: const Text("是否确定删除回忆？"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("取消"),
                        ),
                        FlatButton(
                          onPressed: () async {
                            try {
                              await provider?.open();
                              await provider?.delete(diary.id);
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                            } catch (e) {
                              Toast.show('删除回忆错误！错误信息$e');
                            } finally {
                              await provider?.close();
                            }
                          },
                          child: const Text("确认"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: <Widget>[
              SelectRowWidget(
                title: '时间',
                content:
                    '${DateUtil.formatDateMs(diary?.date, format: 'yyyy年MM月dd日')}',
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    locale: DateTimePickerLocale.zh_cn,
                    onClose: () {},
                    onConfirm: (dateTime, selectedIndex) {
                      setState(() {
                        diary.date = dateTime.millisecondsSinceEpoch;
                      });
                    },
                  );
                },
              ),
              Gaps.hLine,
              EditRowWidget(
                title: '成就',
                controller: achievementController,
              ),
              Gaps.hLine,
              EditRowWidget(
                title: '节日',
                controller: festivalController,
              ),
              Gaps.hLine,
              TextAreaWidget(
                maxLines: 4,
                title: '内容',
                controller: contentController,
                hintText: '请输入内容',
              ),
              Gaps.hLine,
              Gaps.vGap5,
              //没有选取附件则隐藏GridView
              Offstage(
                offstage:
                    diary.imageList == null || diary.imageList.length == 0,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 5,
                  ),
                  children: List.generate(
                    diary.imageList == null ? 0 : diary.imageList.length,
                    (index) {
                      String path = join(
                          SpUtil.getString('sdcard'), diary.imageList[index]);
                      return Image.file(
                        File(path),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                        cacheWidth: 100,
                      );
                    },
                  ),
                ),
              ),
              Gaps.vGap5,
              Row(
                children: <Widget>[
                  ClipButton(
                    text: '选择图片',
                    height: 43,
                    icon: Icons.image,
                    color: Colors.pinkAccent,
                    onTap: () async {
                      assetList = await SystemUtils.loadAssets(assetList);
                      diary.images =
                          (await Future.wait(assetList.map((asset) async {
                        File file = File(join(
                            await FileUtils.getSDCardDirectory(), asset.name));
                        ByteData byteData = await asset.getByteData();
                        await file.writeAsBytes(byteData.buffer.asUint8List());
                        return asset.name;
                      }).toList()))
                              .join(',');
                      setState(() {});
                    },
                  ),
                  Gaps.hGap20,
                  ClipButton(
                    text: () {
                      if (widget.type == 0) {
                        return '添加回忆';
                      } else if (widget.type == 1) {
                        return '修改回忆';
                      } else {
                        return '未知类型type=${widget.type}';
                      }
                    }(),
                    height: 43,
                    icon: Icons.note_add,
                    color: Colors.pinkAccent,
                    onTap: () async {
                      if (diary.date == null) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: const Text('请选择时间！'),
                            action: SnackBarAction(
                              label: '我知道了',
                              onPressed: () {},
                            ),
                          ),
                        );
                      } else if (contentController.text == null ||
                          contentController.text == '') {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: const Text('请输入内容！'),
                            action: SnackBarAction(
                              label: '我知道了',
                              onPressed: () {},
                            ),
                          ),
                        );
                      } else {
                        try {
                          await provider?.open();
                          diary.content = contentController.text;
                          diary.festival = festivalController.text;
                          diary.achievement = achievementController.text;
                          if (widget.type == 0) {
                            await provider.insert(diary);
                          } else if (widget.type == 1) {
                            await provider.update(diary);
                          } else {
                            throw Exception('未知的类型,type=${widget.type}');
                          }
                          Navigator.pop(context, true);
                        } catch (e) {
                          Toast.show('更新回忆错误！错误信息$e');
                        } finally {
                          await provider?.close();
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
