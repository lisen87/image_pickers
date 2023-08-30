import 'dart:async';

import 'package:flutter/services.dart';

enum GalleryMode {
  ///选择图片
  image,

  ///选择视频
  video,

  ///选择 图片 和 视频
  all,
}

enum CameraMimeType {
  ///拍照
  photo,

  ///拍视频
  video,
}

class ImagePickers {
  static const MethodChannel _channel =
      const MethodChannel('flutter/image_pickers');

  /// 返回拍摄的图片或视频的信息 Return information of the selected picture or video
  ///
  /// cameraMimeType CameraMimeType.photo为拍照，CameraMimeType.video 为录制视频 CameraMimeType.photo is a photo, CameraMimeType.video is a video
  ///
  ///cropConfig 裁剪配置（视频不支持裁剪和压缩，当选择视频时此参数无效） Crop configuration (video does not support cropping and compression, this parameter is not available when selecting video)
  ///
  ///compressSize 拍照后（录制视频时此参数无效）的忽略压缩大小，当图片大小小于compressSize时将不压缩 单位 KB Ignore compression size after selection, will not compress unit KB when the image size is smaller than compressSize
  ///
  /// videoRecordMaxSecond 录制视频最大时间（秒）
  ///
  /// videoRecordMinSecond 录制视频最最小时间（秒）
  ///

  static Future<Media?> openCamera({
    CameraMimeType cameraMimeType = CameraMimeType.photo,
    CropConfig? cropConfig,
    int compressSize = 500,
    int videoRecordMaxSecond = 120,
    int videoRecordMinSecond = 1,
    Language language = Language.system,
  }) async {

    bool enableCrop = false;
    int width = -1;
    int height = -1;
    if (cropConfig != null) {
      enableCrop = cropConfig.enableCrop;
      width = cropConfig.width <= 0 ? -1 : cropConfig.width;
      height = cropConfig.height <= 0 ? -1 : cropConfig.height;
    }

    Color uiColor = UIConfig.defUiThemeColor;
    final Map<String, dynamic> params = <String, dynamic>{
      'galleryMode': "image",
      'showGif': true,
      'uiColor': {
        "a": 255,
        "r": uiColor.red,
        "g": uiColor.green,
        "b": uiColor.blue,
        "l": (uiColor.computeLuminance() * 255).toInt()
      },
      'selectCount': 1,
      'showCamera': false,
      'enableCrop': enableCrop,
      'width': width,
      'height': height,
      'compressSize': compressSize < 50 ? 50 : compressSize,
      'cameraMimeType': cameraMimeType.name,
      'videoRecordMaxSecond': videoRecordMaxSecond,
      'videoRecordMinSecond': videoRecordMinSecond,
      'language': language.name,
    };
    final List<dynamic>? paths =
        await _channel.invokeMethod('getPickerPaths', params);

    if (paths != null && paths.length > 0) {
      Media media = Media();
      media.thumbPath = paths[0]["thumbPath"];
      media.path = paths[0]["path"];
      if(cameraMimeType == CameraMimeType.photo){
        media.galleryMode = GalleryMode.image;
      }else{
        media.galleryMode = GalleryMode.video;
      }
      return media;
    }

    return null;
  }

  ///选择图片或视频 Choose an image or video
  ///
  ///返回选择的图片或视频的信息 Return information of the selected picture or video
  ///
  ///
  ///galleryMode 选择图片或者选择视频 枚举 Select an image or select a video to enumerate
  ///
  /// uiConfig 选择图片或选择视频页面的主题 默认 0xfffefefe Select an image or select the theme of the video page Default 0xfffefefe
  ///
  ///selectCount 要选择的图片数量 Number of images to select
  ///
  ///showCamera 是否显示相机按钮 Whether to display the camera button
  ///
  ///cropConfig 裁剪配置（视频不支持裁剪和压缩，当选择视频时此参数无效） Crop configuration (video does not support cropping and compression, this parameter is not available when selecting video)
  ///
  ///compressSize 选择图片（选择视频时此参数无效）后的忽略压缩大小，当图片大小小于compressSize时将不压缩 单位 KB Ignore compression size after selection, will not compress unit KB when the image size is smaller than compressSize
  ///
  ///
  /// videoRecordMaxSecond 录制视频最大时间（秒）
  ///
  /// videoRecordMinSecond 录制视频最最小时间（秒）
  ///
  /// videoSelectMaxSecond 选择视频时视频最大时间（秒）
  ///
  /// videoSelectMinSecond 选择视频时视频最小时间（秒）

  static Future<List<Media>> pickerPaths({
    GalleryMode galleryMode = GalleryMode.image,
    UIConfig? uiConfig,
    int selectCount = 1,
    bool showCamera = false,
    bool showGif = true,
    CropConfig? cropConfig,
    int compressSize = 500,
    int videoRecordMaxSecond = 120,
    int videoRecordMinSecond = 1,
    int videoSelectMaxSecond = 120,
    int videoSelectMinSecond = 1,
    Language language = Language.system,
  }) async {
    Color uiColor = UIConfig.defUiThemeColor;
    if (uiConfig != null) {
      uiColor = uiConfig.uiThemeColor;
    }

    bool enableCrop = false;
    int width = -1;
    int height = -1;
    if (cropConfig != null) {
      enableCrop = cropConfig.enableCrop;
      width = cropConfig.width <= 0 ? -1 : cropConfig.width;
      height = cropConfig.height <= 0 ? -1 : cropConfig.height;
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'galleryMode': galleryMode.name,
      'showGif': showGif,
      'uiColor': {
        "a": 255,
        "r": uiColor.red,
        "g": uiColor.green,
        "b": uiColor.blue,
        "l": (uiColor.computeLuminance() * 255).toInt()
      },
      'selectCount': selectCount,
      'showCamera': showCamera,
      'enableCrop': enableCrop,
      'width': width,
      'height': height,
      'compressSize': compressSize < 50 ? 50 : compressSize,
      'videoRecordMaxSecond': videoRecordMaxSecond,
      'videoRecordMinSecond': videoRecordMinSecond,
      'videoSelectMaxSecond': videoSelectMaxSecond,
      'videoSelectMinSecond': videoSelectMinSecond,
      'language': language.name,
    };
    final List<dynamic> paths =
        await _channel.invokeMethod('getPickerPaths', params);
    List<Media> medias = [];
    paths.forEach((data) {
      Media media = Media();
      media.thumbPath = data["thumbPath"];
      media.path = data["path"];
      if(media.path == media.thumbPath){
        media.galleryMode = GalleryMode.image;
      }else{
        media.galleryMode = GalleryMode.video;
      }
      medias.add(media);
    });
    return medias;
  }

  ///预览图片 preview picture
  ///
  ///imagePath 图片本地路径或者网络url Image local path or web url

  static previewImage(String imagePath) {
    final Map<String, dynamic> params = <String, dynamic>{
      'path': imagePath,
    };
    _channel.invokeMethod('previewImage', params);
  }

  ///预览多张图片和视频 Preview multiple pictures and multiple videos
  ///
  ///imagePaths 图片/视频本地路径集合或者网络url集合 Image or videos local path collection or network url collection

  static previewImages(List<String?> imagePaths, int initIndex) {
    final Map<String, dynamic> params = <String, dynamic>{
      'paths': imagePaths,
      'initIndex': initIndex,
    };
    _channel.invokeMethod('previewImages', params);
  }

  ///预览多张图片和视频  Preview multiple pictures and multiple videos
  ///
  ///imageMedias 图片/视频 数据集合 Image videos local path collection or network url collection
  ///
  ///Media中真正有效使用的数据是 Media.path The really effectively used data in Media is Media.path
  ///
  static previewImagesByMedia(List<Media> imageMedias, int initIndex) {
    if (imageMedias.length > 0) {
      List<String?> paths =
          imageMedias.map((Media media) => media.path).toList();
      previewImages(paths, initIndex);
    }
  }

  ///预览视频 Preview video
  ///
  /// videoPath 图片本地路径或者网络url Image local path or web url
  ///
  /// thumbPath 视频封面图 Video cover

  static previewVideo(String videoPath, {String thumbPath = ""}) {
    final Map<String, dynamic> params = <String, dynamic>{
      'path': videoPath,
      'thumbPath': thumbPath,
    };
    _channel.invokeMethod('previewVideo', params);
  }

  ///保存图片字节到相册中 Save picture bytes to album
  ///
  /// data 图片字节数据 Picture byte data
  ///

  static Future<String?> saveByteDataImageToGallery(
    Uint8List data,
  ) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'uint8List': data,
    };
    String? path =
        await _channel.invokeMethod('saveByteDataImageToGallery', params);
    return path;
  }

  ///保存图片到相册中 Save image to album
  ///
  /// 返回保存的图片路径 Return the saved image path
  ///
  /// imageUrl 网络图片url Web image url

  static Future<String?> saveImageToGallery(String imageUrl) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'path': imageUrl,
    };
    String? path = await _channel.invokeMethod('saveImageToGallery', params);
    return path;
  }

  ///保存视频到相册中 Save video to album
  ///
  /// 返回保存的视频路径 Android 返回保存的视频文件路径 ios 暂无法返回本地视频路径
  /// Return the saved video path Android returns the saved video file path ios can not return to the local video path
  ///
  /// videoUrl 网络视频url Web video url
  ///
  static Future<String?> saveVideoToGallery(String videoUrl) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'path': videoUrl,
    };
    String? path = await _channel.invokeMethod('saveVideoToGallery', params);
    return path;
  }
}

///裁剪配置
///Crop configuration
class CropConfig {
  ///是否可裁剪
  bool enableCrop = false;

  ///裁剪的宽度比例
  ///Cropped width ratio
  int width = -1;

  ///裁剪的高度比例
  ///Crop height ratio
  int height = -1;

  CropConfig({this.enableCrop = false, this.width = -1, this.height = -1});
}

class Media {
  ///视频缩略图图片路径
  ///Video thumbnail image path
  String? thumbPath;

  ///视频路径或图片路径
  ///Video path or image path
  String? path;
  GalleryMode? galleryMode;

  @override
  String toString() {
    return '( thumbPath = $thumbPath, path = $path, galleryMode = ${galleryMode?.name} )';
  }
}

/// Created by liSen on 2019/11/15 10:51.
///
/// @author liSen < 453354858@qq.com >
///
/// 选择图片页面颜色配置
///
/// Select image page color configuration
///
class UIConfig {
  static const Color defUiThemeColor = Color(0xfffefefe);
  Color uiThemeColor;

  /// uiThemeColor
  UIConfig({this.uiThemeColor = defUiThemeColor});
}

enum Language {
  /// 系统语言
  system,

  /// 中文简体
  chinese,

  /// 中文繁体
  traditional_chinese,

  /// 英语
  english,

  /// 日语
  japanese,

  /// 法语
  france,

  /// 德语
  german,

  /// 俄语
  russian,

  /// 越语
  vietnamese,

  /// 韩语
  korean,

  /// 葡萄牙语
  portuguese,

  /// 西班牙语
  spanish,

  /// 阿拉伯语
  arabic,
}
