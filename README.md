# [pickers](https://github.com/lisen87/pickers.git)

image_pickers Support picture selection, video multiple selection, support to save network pictures to albums, support preview video and preview picture function

> Supported  Platforms
> * Android
> * iOS

## How to Use

```yaml
# add this line to your dependencies
image_pickers: ^1.0.2
```

```dart
import 'package:image_pickers/image_pickers.dart';
import 'package:image_pickers/CorpConfig.dart';
import 'package:image_pickers/Media.dart';
```
```dart

///选择图片 select images
Future<void> selectImages() async {
    List<Media> _listImagePaths = await ImagePickers.pickerPaths(
              galleryMode: GalleryMode.image,
              selectCount: 2,
              showCamera: true,
              compressSize: 300,
              corpConfig: CorpConfig(enableCrop: true, width: 2, height: 1));
  }

/// 或者 or
ImagePickers.pickerPaths().then((List medias){
      
    });

```
```dart
///选择视频 select Videos
Future<void> selectVideos() async {
   List<Media> _listVideoPaths = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.video,
          selectCount: 5,
        );
  }
```

```dart
///预览图片 preview picture
ImagePickers.previewImage(_listImagePaths[index].path);

///预览视频 Preview video
ImagePickers.previewVideo(_listVideoPaths[index].path);
```
```dart
///保存图片到图库 Save image to gallery
ImagePickers.saveImageToGallery("http://i1.sinaimg.cn/ent/d/2008-06-04/U105P28T3D2048907F326DT20080604225106.jpg");
```

