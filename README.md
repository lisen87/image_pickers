# [image_pickers](https://github.com/lisen87/image_pickers)

image_pickers支持本地图片多选，本地视频多选，支持将网络图片保存到相册，支持截图保存到相册，支持将网络视频保存到相册，支持预览视频和预览图片功能，支持主题颜色设置

image pickers support multi-selection of local pictures, multi-selection of local videos, support for saving network pictures to albums, support for saving screenshots to albums, support for saving network videos to albums, support for preview videos and preview images, and support for theme color settings

> Supported  Platforms
> * Android
> * iOS

## iOS : platform :ios, '10.0'


## 注意 ---> Android请指定您项目中 : targetSdkVersion 34 compileSdkVersion 34,否则 Android 13 可能会出现 无法正常访问图片！
## 注意 ---> Android请指定您项目中 : targetSdkVersion 34 compileSdkVersion 34,否则 Android 13 可能会出现 无法正常访问图片！
## 注意 ---> Android请指定您项目中 : targetSdkVersion 34 compileSdkVersion 34,否则 Android 13 可能会出现 无法正常访问图片！


## How to Use

```yaml
# add this line to your dependencies
image_pickers: ^2.0.6
```

```dart
import 'package:image_pickers/image_pickers.dart';
```
```dart


///选择多张图片 Select multiple images
Future<void> selectImages() async {
    List<Media> _listImagePaths = await ImagePickers.pickerPaths(
              galleryMode: GalleryMode.image,
              selectCount: 2,
              showGif: false,
              showCamera: true,
              compressSize: 500,
              uiConfig: UIConfig(uiThemeColor: Color(0xffff0f50)),
              cropConfig: CropConfig(enableCrop: false, width: 2, height: 1));
  }

/// 或者 or
ImagePickers.pickerPaths().then((List medias){
      /// medias 照片路径信息 Photo path information
    });

```
```dart
///选择多个视频 Select multiple videos
Future<void> selectVideos() async {
   List<Media> _listVideoPaths = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.video,
          selectCount: 5,
        );
  }
```
```dart
///直接打开相机拍摄图片 Open the camera directly to take a picture
ImagePickers.openCamera().then((Media? media){
    /// media 包含照片路径信息 Include photo path information
    /// 未拍照返回 media = null
    if(media != null){
        
    }
  });

```

```dart
///直接打开相机拍摄视频 Open the camera directly to shoot the video
ImagePickers.openCamera(cameraMimeType: CameraMimeType.video).then((media){
    /// media 包含视频路径信息 Contains video path information
    /// 未拍摄视频返回 media = null
    if(media != null){
            
    }
  });

```

```dart
///预览图片 Preview picture
ImagePickers.previewImage(_listImagePaths[index].path);

///预览多张图片或视频 Preview multiple pictures or videos
ImagePickers.previewImagesByMedia(_listImagePaths,index);
///预览多张图片或视频  Preview multiple pictures or videos
ImagePickers.previewImages(paths,index);

///预览视频 Preview video
ImagePickers.previewVideo(_listVideoPaths[index].path);
```
```dart
///保存图片到图库 Save image to gallery
ImagePickers.saveImageToGallery("http://i1.sinaimg.cn/ent/d/2008-06-04/U105P28T3D2048907F326DT20080604225106.jpg");
```

```dart
/// 保存截图图片 ByteData 到图库 Save screenshot image ByteData to gallery
RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
ui.Image image = await boundary.toImage(pixelRatio: 3);
ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
Uint8List data = byteData.buffer.asUint8List();

String dataImagePath = await ImagePickers.saveByteDataImageToGallery(data,);

```


```dart
///保存视频到图库 Save video to gallery
ImagePickers.saveVideoToGallery("http://xxxx/xx/xx.mp4");
```

## iOS
Add the following entry to your `Info.plist` file, located in `/Info.plist` :

    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    <key>NSMicrophoneUsageDescription</key>
    <string>...</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>...</string>
    <key>NSCameraUsageDescription</key>
    <string>...</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>...</string>







