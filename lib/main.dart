import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:love_diary/res/colors.dart';
import 'package:love_diary/res/gaps.dart';
import 'package:love_diary/util/file_utils.dart';
import 'package:love_diary/util/ui_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart';

import 'add_diary_page.dart';
import 'bean/diary.dart';
import 'common/common_widget.dart';
import 'util/toast_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  SpUtil.putString('sdcard', await FileUtils.getSDCardDirectory());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: '猪头日记',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale.fromSubtags(languageCode: 'zh'),
        ],
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int limit = 10;
  int offset = 0;
  final DiaryProvider provider = DiaryProvider();
  final List<Diary> diaryList = List<Diary>();
  final EasyRefreshController refreshController = EasyRefreshController();
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer.open(AssetsAudio(
      asset: "my_secret.mp3",
      folder: "assets/music/",
    ));
    assetsAudioPlayer.finished.listen((finished){
      assetsAudioPlayer.playOrPause();
    });
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我们已经认识${getDays()}天'),
        centerTitle: true,
      ),
      body: EasyRefresh.custom(
        firstRefresh: true,
        controller: refreshController,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        header: UIUtils.getRefreshClassicalHeader(),
        footer: UIUtils.getLoadClassicalFooter(),
        onRefresh: () async {
          try {
            offset = 0;
            await provider?.open();
            diaryList.clear();
            List<Diary> tempList =
                await provider.getDiaryList(limit: limit, offset: offset);
            diaryList.addAll(tempList);
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
            await provider.open();
            List<Diary> tempList =
                await provider.getDiaryList(limit: limit, offset: offset);
            diaryList.addAll(tempList);
            if (tempList.length < limit) {
              refreshController.finishLoad(success: true, noMore: true);
            } else {
              refreshController.finishLoad(success: true, noMore: false);
            }
          } catch (e) {
            Toast.show('$e');
          } finally {
            await provider.close();
            setState(() {});
          }
          return;
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                //创建列表项
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: InkWellButton(
                    onLongPress: () async {
                      bool success = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddDiaryPage(
                            diary: diaryList[index],
                            type: 1,
                          ),
                        ),
                      );
                      if (success) {
                        refreshController.callRefresh();
                      }
                    },
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            UIUtils.getBoxShadow(),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DateUtil.formatDateMs(diaryList[index].date, format: 'yyyy年MM月dd日')}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Offstage(
                                  offstage: TextUtil.isEmpty(
                                      diaryList[index].festival),
                                  child: Row(
                                    children: <Widget>[
                                      Gaps.hGap10,
                                      Image.asset(
                                        'assets/images/icon_festival.png',
                                        width: 15,
                                        height: 15,
                                        fit: BoxFit.cover,
                                      ),
                                      Gaps.hGap6,
                                      Text(
                                        '${diaryList[index].festival}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.pinkAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gaps.vGap8,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${diaryList[index].content}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colours.secondary_text),
                                  ),
                                ),
                              ],
                            ),
                            Gaps.vGap5,
                            Offstage(
                              offstage: diaryList[index].imageList == null || diaryList[index].imageList.length == 0,
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
                                  diaryList[index].imageList == null ? 0 : diaryList[index].imageList.length,
                                      (imageIndex) {
                                    String path = join(
                                        SpUtil.getString('sdcard'), diaryList[index].imageList[imageIndex]);
                                    return Image.file(
                                      File(path),
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                            Gaps.vGap5,
                            Offstage(
                              offstage: TextUtil.isEmpty(
                                  diaryList[index].achievement),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      '🥇 已解锁成就"${diaryList[index].achievement}"',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.pinkAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: diaryList.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool success = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDiaryPage(type: 0)),
          );
          if (success != null && success) {
            refreshController.callRefresh();
          }
        },
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.favorite),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 46,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              InkWell(
                onTap: (){
                  assetsAudioPlayer.playOrPause();
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/my_secret.jpg'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '我的秘密',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    'G.E.M. 邓紫棋',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
//              Container(
//                width: 110,
//                child: Text(
//                  '看着窗外的小星星\n心里想着我的秘密',
//                  textAlign: TextAlign.center,
//                  style: TextStyle(fontSize: 10),
//                ),
//              ),
              SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  static int getDays() {
    DateTime firstTime = DateTime(2020, 1, 20, 19, 30);
    Duration duration = DateTime.now().difference(firstTime);
    return duration.inDays;
  }
}
