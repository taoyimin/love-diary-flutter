import 'package:love_diary/util/toast_utils.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

/// 系统工具类
///
/// 用于调用系统相关功能
class SystemUtils {

  /// 调用图片选择器 [selectedAssets]为默认选中的图片
  static Future<List<Asset>> loadAssets(List<Asset> selectedAssets, {int maxImages=20}) async {
    List<Asset> resultAssets;
    try {
      resultAssets = await MultiImagePicker.pickImages(
        enableCamera: true,
        maxImages: maxImages,
        selectedAssets: selectedAssets ?? List<Asset>(),
        materialOptions: MaterialOptions(
          actionBarTitle: '选取图片',
          allViewTitle: '全部图片',
          actionBarColor: '#FF4081',
          actionBarTitleColor: '#FFFFFF',
          lightStatusBar: false,
          statusBarColor: '#C2185B',
          startInAllView: false,
          useDetailsView: true,
          textOnNothingSelected: '没有选中任何图片',
          selectCircleStrokeColor: '#FFFFFF',
          selectionLimitReachedText: '已达到可选图片最大数',
        ),
      );
    } on NoImagesSelectedException {
      //Toast.show('没有选择任何图片');
      return selectedAssets;
    } on Exception catch (e) {
      Toast.show('选择图片错误！错误信息：$e');
    }
    return resultAssets ?? List<Asset>();
  }
}
