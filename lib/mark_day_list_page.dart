import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:love_diary/add_mark_day_page.dart';
import 'package:love_diary/res/colors.dart';
import 'package:love_diary/res/gaps.dart';
import 'package:love_diary/util/toast_utils.dart';
import 'package:love_diary/util/ui_utils.dart';
import 'package:path/path.dart';

import 'bean/mark_day.dart';

class MarkDayListPage extends StatefulWidget {
  MarkDayListPage({Key key}) : super(key: key);

  @override
  _MarkDayListPageState createState() => _MarkDayListPageState();
}

class _MarkDayListPageState extends State<MarkDayListPage> {
  int limit = 100;
  int offset = 0;
  final MarkDayProvider provider = MarkDayProvider();
  final List<MarkDay> markDayList = List<MarkDay>();
  final EasyRefreshController refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      appBar: AppBar(
        title: const Text('纪念日'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              bool success = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddMarkDayPage(type: 0)),
              );
              if (success != null && success) {
                refreshController.callRefresh();
              }
            },
          ),
        ],
      ),
      body: EasyRefresh.custom(
        firstRefresh: true,
        controller: refreshController,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        header: UIUtils.getRefreshClassicalHeader2(),
        footer: UIUtils.getLoadClassicalFooter2(),
        onRefresh: () async {
          try {
            offset = 0;
            await provider?.open();
            markDayList.clear();
            List<MarkDay> tempList =
                await provider?.getMarkDayList(limit: limit, offset: offset);
            markDayList.addAll(tempList);
            refreshController.resetLoadState();
            refreshController.finishRefresh(success: true);
          } catch (e) {
            Toast.show('$e');
          } finally {
            await provider?.close();
            setState(() {});
          }
          return;
        },
        onLoad: () async {
          try {
            offset = offset + limit;
            await provider?.open();
            List<MarkDay> tempList =
                await provider?.getMarkDayList(limit: limit, offset: offset);
            markDayList.addAll(tempList);
            if (tempList.length < limit) {
              refreshController.finishLoad(success: true, noMore: true);
            } else {
              refreshController.finishLoad(success: true, noMore: false);
            }
          } catch (e) {
            Toast.show('$e');
          } finally {
            await provider?.close();
            setState(() {});
          }
          return;
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                String path =
                    join(SpUtil.getString('sdcard'), markDayList[index].images);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onLongPress: () async {
                      bool success = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMarkDayPage(
                            markDay: markDayList[index],
                            type: 1,
                          ),
                        ),
                      );
                      if (success != null && success) {
                        refreshController.callRefresh();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                '${markDayList[index].content}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colours.primary_text,
                                ),
                              ),
                              Gaps.vGap8,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    () {
                                      if (markDayList[index].type == 0) {
                                        return '${DateTime.now().difference(DateUtil.getDateTimeByMs(markDayList[index].date)).inDays}';
                                      } else if (markDayList[index].type == 1) {
                                        return '${DateUtil.getDateTimeByMs(markDayList[index].date).difference(DateTime.now()).inDays + 1}';
                                      } else {
                                        return '未知的类型type=${markDayList[index].type}';
                                      }
                                    }(),
                                    style: TextStyle(
                                      color: Colors.pinkAccent,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Gaps.hGap10,
                                  const Text(
                                    '天',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              Gaps.vGap8,
                              Text(
                                () {
                                  if (markDayList[index].type == 0) {
                                    return '起始日：${DateUtil.formatDateMs(markDayList[index].date, format: 'yyyy年MM月dd日')}';
                                  } else if (markDayList[index].type == 1) {
                                    return '目标日：${DateUtil.formatDateMs(markDayList[index].date, format: 'yyyy年MM月dd日')}';
                                  } else {
                                    return '未知的类型type=${markDayList[index].type}';
                                  }
                                }(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colours.secondary_text,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Offstage(
                              offstage: TextUtil.isEmpty(markDayList[index].images),
                              child: Image.file(File(path)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: markDayList.length,
            ),
          ),
        ],
      ),
    );
  }
}
