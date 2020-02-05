import 'package:flutter/material.dart';
import 'package:love_diary/util/ui_utils.dart';

import 'common/common_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: false,
            snap: false,
            //expandedHeight: 180,
            title: Text('我们已经认识${getDays()}天'),
            centerTitle: true,
//            flexibleSpace: FlexibleSpaceBar(
//              background: Container(
//                decoration: BoxDecoration(
//                  image: DecorationImage(
//                    image: AssetImage(
//                      'assets/images/home_header_background.png',
//                    ),
//                    fit: BoxFit.cover,
//                  ),
//                ),
//                child: Container(
//                  height: 180,
//                  color: Colors.pinkAccent,
//                  child: Stack(
//                    children: <Widget>[
//                      Positioned(
//                        top: 0,
//                        left: 0,
//                        child: Container(
//                          height: 120,
//                          width: 120,
//                          color: Colors.black,
//                        ),
//                      ),
//                      Positioned(
//                        top: 0,
//                        left: 120,
//                        child: Container(
//                          height: 100,
//                          width: 140,
//                          color: Colors.green,
//                        ),
//                      ),
//                      Positioned(
//                        top: 120,
//                        left: 0,
//                        child: Container(
//                          height: 90,
//                          width: 120,
//                          color: Colors.red,
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
            backgroundColor: Colors.pinkAccent,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                //创建列表项
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: InkWellButton(
                    onTap: () {},
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            UIUtils.getBoxShadow(),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text('第一次见面'),
                            ),
                            Text('2020年1月20日'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
              Container(
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
              Container(
                width: 110,
                child: Text(
                  '看着窗外的小星星\n心里想着我的秘密',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
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

  static List<Diary> getDiaryList() {
    return [
      Diary(content: '第一次打电话，打了2小时16分11秒', time: '2020年1月29日'),
      Diary(content: '在梦时代广场第一次见面', time: '2020年1月20日'),
    ];
  }
}

class Diary {
  String content;
  String time;

  Diary({this.content, this.time});
}
