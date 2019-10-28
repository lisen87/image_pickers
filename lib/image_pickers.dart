import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_pickers/CorpConfig.dart';
import 'package:image_pickers/Media.dart';

enum GalleryMode {
  ///选择图片
  image,

  ///选择视频
  video,
}

class ImagePickers {
  static const MethodChannel _channel =
      const MethodChannel('flutter/image_pickers');

  ///选择图片或视频 Choose an image or video
  ///
  ///返回选择的图片或视频的信息 Return information of the selected picture or video
  ///
  ///
  ///galleryMode 选择图片或者选择视频 枚举 Select an image or select a video to enumerate
  ///
  ///selectCount 要选择的图片数量 Number of images to select
  ///
  ///showCamera 是否显示相机按钮 Whether to display the camera button
  ///
  ///corpConfig 裁剪配置（视频不支持裁剪和压缩，当选择视频时此参数无效） Crop configuration (video does not support cropping and compression, this parameter is not available when selecting video)
  ///
  ///compressSize 选择后的压缩大小 单位 KB Compressed size after selection in KB
  ///

  static Future<List<Media>> pickerPaths({
    GalleryMode galleryMode: GalleryMode.image,
    int selectCount: 1,
    bool showCamera: false,
    CorpConfig corpConfig,
    int compressSize: 500,
  }) async {
    String gMode = "image";
    if (galleryMode == GalleryMode.image) {
      gMode = "image";
    } else if (galleryMode == GalleryMode.video) {
      gMode = "video";
    }

    bool enableCrop = false;
    int width = 1;
    int height = 1;
    if (corpConfig != null) {
      enableCrop = corpConfig.enableCrop;
      width = corpConfig.width <= 0 ? 1 : corpConfig.width;
      height = corpConfig.height <= 0 ? 1 : corpConfig.height;
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'galleryMode': gMode,
      'selectCount': selectCount,
      'showCamera': showCamera,
      'enableCrop': enableCrop,
      'width': width,
      'height': height,
      'compressSize': compressSize < 50 ? 50 : compressSize,
    };
    final List<dynamic> paths =
        await _channel.invokeMethod('getPickerPaths', params);
    List<Media> medias = List();
    paths.forEach((data) {
      Media media = Media();
      media.thumbPath = data["thumbPath"];
      media.path = data["path"];
      media.galleryMode = galleryMode;
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

  ///预览视频 Preview video
  ///
  /// videoPath 图片本地路径或者网络url Image local path or web url
  ///
  /// thumbPath 视频封面图 Video cover

  static previewVideo(String videoPath, {String thumbPath: ""}) {
    final Map<String, dynamic> params = <String, dynamic>{
      'path': videoPath,
      'thumbPath': thumbPath,
    };
    _channel.invokeMethod('previewVideo', params);
  }

  ///保存图片到相册中 Save image to album
  ///
  /// 返回保存的图片路径 Return the saved image path
  ///
  /// imageUrl 网络图片url Web image url

  static Future<String> saveImageToGallery(String imageUrl) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'path': imageUrl,
    };
    String path = await _channel.invokeMethod('saveImageToGallery', params);
    return path;
  }

  static Future<String> saveVideoToGallery(String videoUrl) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'path': videoUrl,
    };
    String path = await _channel.invokeMethod('saveVideoToGallery', params);
    return path;
  }
}
