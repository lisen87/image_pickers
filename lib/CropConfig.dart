///裁剪配置
///Crop configuration
class CropConfig {
  ///是否可裁剪
  bool enableCrop = false;

  ///裁剪的宽度比例
  ///Cropped width ratio
  int width = 1;

  ///裁剪的高度比例
  ///Crop height ratio
  int height = 1;

  CropConfig({this.enableCrop: false, this.width: 1, this.height: 1});
}
