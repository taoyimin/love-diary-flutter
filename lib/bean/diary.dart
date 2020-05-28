import 'package:love_diary/res/constants.dart';
import 'package:love_diary/util/file_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableDiary = 'diary';
final String columnId = '_id';
final String columnContent = 'content';
final String columnFestival = 'festival';
final String columnAchievement = 'achievement';
final String columnDate = 'date';
final String columnImages = 'images';

/// 预留列
final String column1 = 'column1';
final String column2 = 'column2';
final String column3 = 'column3';

class Diary {
  int id;
  String content;
  String festival;
  String achievement;
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
      columnFestival: festival,
      columnAchievement: achievement,
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

  Diary();

  Diary.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[columnContent];
    festival = map[columnFestival];
    achievement = map[columnAchievement];
    date = map[columnDate];
    images = map[columnImages];
    field1 = map[column1];
    field2 = map[column2];
    field3 = map[column3];
  }
}

class DiaryProvider {
  Database db;

  Future open() async {
    db = await openDatabase(
      join(await FileUtils.getSDCardDirectory(), 'diary_db.db'),
      version: Constants.DATABASE_VERSION,
      onCreate: (Database db, int version) async {
        print('创建日记表');
        await db.execute('''
create table $tableDiary ( 
  $columnId integer primary key autoincrement, 
  $columnContent text not null,
  $columnFestival text,
  $columnAchievement text,
  $columnDate timestamp not null,
  $columnImages text,
  $column1 text,
  $column2 text,
  $column3 text)
''');
      },
    );
  }

  Future<Diary> insert(Diary diary) async {
    diary.id = await db.insert(tableDiary, diary.toMap());
    return diary;
  }

  Future<Diary> getDiary(int id) async {
    List<Map> maps = await db.query(tableDiary,
        columns: [
          columnId,
          columnFestival,
          columnContent,
          columnAchievement,
          columnDate,
          columnImages,
          column1,
          column2,
          column3,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Diary.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Diary>> getDiaryList({limit = 0, offset = 20}) async {
    return await db
        .query(tableDiary,
            limit: limit, offset: offset, orderBy: '$columnDate DESC')
        .then((maps) {
      return maps.map<Diary>((map) {
        return Diary.fromMap(map);
      }).toList();
    });
  }

  Future<int> delete(int id) async {
    return await db.delete(tableDiary, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Diary diary) async {
    return await db.update(tableDiary, diary.toMap(),
        where: '$columnId = ?', whereArgs: [diary.id]);
  }

  Future close() async => db.close();
}
