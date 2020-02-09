import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  //获取app根目录
  static Future<String> getApplicationDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    bool exists = await appDocDir.exists();
    if (!exists) {
      await appDocDir.create();
    }
    return appDocDir.path;
  }

  //获取sd卡根目录
  static Future<String> getSDCardDirectory() async {
    Directory sdCardDir = await getExternalStorageDirectory();
    bool exists = await sdCardDir.exists();
    if (!exists) {
      await sdCardDir.create();
    }
    return sdCardDir.path;
  }

  //根据文件名获取本地路径 传入真实文件名
  static Future<String> getAttachmentLocalPathByFileName(
      String fileName) async {
    return '${await getApplicationDirectory()}/$fileName';
  }

  //清空缓存文件
  static Future<void> clearApplicationDirectory() async {
    String appDocDir = await getApplicationDirectory();
    File(appDocDir).deleteSync(recursive: true);
  }
}
