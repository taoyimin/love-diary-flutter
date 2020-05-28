import 'dart:io';
import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:love_diary/bean/mark_day.dart';
import 'package:love_diary/res/colors.dart';
import 'package:love_diary/res/gaps.dart';
import 'package:love_diary/util/file_utils.dart';
import 'package:love_diary/util/system_utils.dart';
import 'package:love_diary/util/toast_utils.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';

import 'bean/data_dict.dart';
import 'common/common_widget.dart';

class AddMarkDayPage extends StatefulWidget {
  final MarkDay markDay;
  final int type; //0:新增 1:修改

  AddMarkDayPage({this.markDay, this.type = 0});

  @override
  _AddMarkDayPageState createState() => _AddMarkDayPageState();
}

class _AddMarkDayPageState extends State<AddMarkDayPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MarkDayProvider provider = MarkDayProvider();
  final TextEditingController contentController = TextEditingController();
  final List<DataDict> dataDictList = [
    DataDict(name: '累计日', code: 0),
    DataDict(name: '倒数日', code: 1)
  ];
  MarkDay markDay;
  List<Asset> assetList;

  @override
  void initState() {
    super.initState();
    markDay = widget.markDay ?? MarkDay();
    contentController.text = markDay.content;
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(() {
          if (widget.type == 0) {
            return '添加纪念日';
          } else if (widget.type == 1) {
            return '修改纪念日';
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
                      title: const Text("删除纪念日"),
                      content: const Text("是否确定删除纪念日？"),
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
                              await provider?.delete(markDay.id);
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                            } catch (e) {
                              Toast.show('删除纪念日错误！错误信息$e');
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
              Container(
                height: 46,
                child: Row(
                  children: <Widget>[
                    Text(
                      '类型',
                      style: const TextStyle(fontSize: 15),
                    ),
                    Gaps.hGap20,
                    Expanded(
                      flex: 1,
                      child: PopupMenuButton<DataDict>(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            () {
                              if (markDay.type == 0 || markDay.type == 1)
                                return '${dataDictList[markDay.type].name}';
                              else
                                return '请选择类型';
                            }(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              color: () {
                                if (markDay.type == 0 || markDay.type == 1)
                                  return Colours.primary_text;
                                else
                                  return Colours.secondary_text;
                              }(),
                            ),
                          ),
                        ),
                        onSelected: (DataDict dataDict) {
                          setState(() {
                            markDay.type = dataDict.code;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return dataDictList
                              .map<PopupMenuItem<DataDict>>((dataDict) {
                            return PopupMenuItem<DataDict>(
                              value: dataDict,
                              child: Text('${dataDict.name}'),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.hLine,
              SelectRowWidget(
                title: '时间',
                content:
                    '${DateUtil.formatDateMs(markDay?.date, format: 'yyyy年MM月dd日')}',
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    locale: DateTimePickerLocale.zh_cn,
                    onClose: () {},
                    onConfirm: (dateTime, selectedIndex) {
                      setState(() {
                        markDay.date = dateTime.millisecondsSinceEpoch;
                      });
                    },
                  );
                },
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
                markDay.imageList == null || markDay.imageList.length == 0,
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
                    markDay.imageList == null ? 0 : markDay.imageList.length,
                        (index) {
                      String path = join(
                          SpUtil.getString('sdcard'), markDay.imageList[index]);
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
                      assetList = await SystemUtils.loadAssets(assetList, maxImages: 1);
                      markDay.images =
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
                        return '添加纪念日';
                      } else if (widget.type == 1) {
                        return '修改纪念日';
                      } else {
                        return '未知类型type=${widget.type}';
                      }
                    }(),
                    height: 43,
                    icon: Icons.note_add,
                    color: Colors.pinkAccent,
                    onTap: () async {
                      if (markDay.date == null) {
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
                          markDay.content = contentController.text;
                          if (widget.type == 0) {
                            await provider?.insert(markDay);
                          } else if (widget.type == 1) {
                            await provider?.update(markDay);
                          } else {
                            throw Exception('未知的类型,type=${widget.type}');
                          }
                          Navigator.pop(context, true);
                        } catch (e) {
                          Toast.show('更新纪念日错误！错误信息$e', duration: 10000);
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
