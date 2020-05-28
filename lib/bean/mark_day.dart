import 'package:love_diary/res/constants.dart';
import 'package:love_diary/util/file_utils.dart';
import 'package:love_diary/util/toast_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableMarkDay = 'mark_day';
final String columnId = '_id';
final String columnContent = 'content';
final String columnType = 'type';
final String columnDate = 'date';
final String columnImages = 'images';

/// 预留列
final String column1 = 'column1';
final String column2 = 'column2';
final String column3 = 'column3';

class MarkDay {
  int id;
  String content;
  int type; // 0:累计日 1:倒数日
  int date;
  String images;

  /// 预留字段
  String field1;
  String field2;
  String field3;

  List<String> get imageList {
    return this.images?.split(',') ?? [];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnContent: content,
      columnType: type,
      columnDate: date,
      columnImages: images,
      column1: field1,
      column2: field2,
      column3: field3,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  MarkDay();

  MarkDay.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[columnContent];
    type = map[columnType];
    date = map[columnDate];
    images = map[columnImages];
    field1 = map[column1];
    field2 = map[column2];
    field3 = map[column3];
  }
}

class MarkDayProvider {
  Database db;

  Future open() async {
    db = await openDatabase(
      join(await FileUtils.getSDCardDirectory(), 'diary_db.db'),
      version: Constants.DATABASE_VERSION,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if(newVersion == 5){
          print('创建纪念日表');
          Toast.show('创建纪念日表');
          try {
            await db.execute('''
create table $tableMarkDay ( 
  $columnId integer primary key autoincrement, 
  $columnContent text not null,
  $columnType integer not null,
  $columnDate timestamp not null,
  $columnImages text,
  $column1 text,
  $column2 text,
  $column3 text)
''');
          } catch (e) {
            Toast.show('创建纪念日表失败：$e');
          }
        }
      },
    );
  }

  Future<MarkDay> insert(MarkDay markDay) async {
    markDay.id = await db.insert(tableMarkDay, markDay.toMap());
    return markDay;
  }

  Future<MarkDay> getMarkDay(int id) async {
    List<Map> maps = await db.query(tableMarkDay,
        columns: [
          columnId,
          columnContent,
          columnType,
          columnDate,
          columnImages,
          column1,
          column2,
          column3,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return MarkDay.fromMap(maps.first);
    }
    return null;
  }

  Future<List<MarkDay>> getMarkDayList({limit = 0, offset = 20}) async {
    return await db
        .query(tableMarkDay, limit: limit, offset: offset)
        .then((maps) {
      return maps.map<MarkDay>((map) {
        return MarkDay.fromMap(map);
      }).toList();
    });
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableMarkDay, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(MarkDay markDay) async {
    return await db.update(tableMarkDay, markDay.toMap(),
        where: '$columnId = ?', whereArgs: [markDay.id]);
  }

  Future close() async => db.close();
}
