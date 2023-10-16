## 2.0.4+5
* 修复 ios 选择gif错误问题
* Fix iOS selection GIF error issue
* 修复 ios 选择 iCloud 文件错误问题
* Fix iOS selection iCloud file error issue
## 2.0.4+4
* 修复 ios 视频选择时间限制无效问题
* Fix iOS video selection time limit invalid issue
## 2.0.4+3
* Android 首次打开相机无响应。
* Android Opening the camera for the first time is unresponsive.
* 保存图片类型问题。
* Save picture type issues.
## 2.0.4+2
* 增加 图片图片任意比例裁剪
* Add Picture image cropping at any scale
## 2.0.4+1
* 增加 视频和图片混合预览
* Add video and picture mixing preview
## 2.0.3+1
* 更新安卓最新图片选择库
* Updated the latest image selection library for Android
* 增加 视频和图片混合选择
* Added video and picture mixing options
* 增加 多图裁剪 ，选择视频最大时间，最小时间参数
* Add multi-image cropping , select the video maximum time, minimum time parameters
* 增加 多语言
* Add multilingual
## 2.0.2+1
* 尝试适配 Android13 权限
## 2.0.1
* 更新ios库，修复找不到方法
* Update iOS library, fix not found way
## 2.0.0+7
* 更新Android库
## 2.0.0+6
* 更新原生库
## 2.0.0+2
* 修复iOS
## 2.0.0+1
* 未选择图片将返回空数组，未拍照或者未拍摄视频将返回null
* If no pictures are selected, an empty array will be returned, and if no pictures or videos are taken, null will be returned
## 2.0.0
* 使用flutter 2.0 迁移至空安全
* Use flutter 2.0 to migrate to null-safety
## 1.1.0
* Android 修复无法加载预览图问题,修改多选图片问题
* iOS 去除了返回箭头，iOS13 报错问题
## 1.0.8+7
* Android 修复打开相册时，无法录制视频问题
* Android fixes the problem that the video cannot be recorded when opening the gallery
## 1.0.8+6
* iOS 尝试修复最近的各种问题
* iOS Try to fix various recent problems
## 1.0.8+4
* 安卓修复安卓Q出现的问题等
* Android fixes problems with Android Q, etc.
* iOS处理包名错误问题等
* iOS handles package name errors, etc.
## 1.0.8+3
* 更新AFNetworking 到4.0 删除UIWebview ，处理iOS上架失败问题
## 1.0.8+2
* 添加是否显示gif图片字段
* Add whether to display the gif image field
* android 更新权限申请流程，不再一次性申请不相关权限
* android Update the permission application process and no longer apply for irrelevant permissions all at once
* iOS14 修复图片预览无法显示问题/修复无法关闭裁剪问题
* iOS14 fixes the problem that picture preview cannot be displayed/Fix the problem that cropping cannot be turned off

## 1.0.7+6
* iOS 固定ZLPhotoBrowser为3.1.2 
* iOS fixed ZLPhotoBrowser to 3.1.2
## 1.0.7+5
* Android 修复保存屏幕截图到相册时，因文件后缀名造成的崩溃问题。
* Android fixes the crash caused by the file extension when saving screenshots to albums.
## 1.0.7+4
* 修复 iOS 因为图片（right_arrow.png、left_arrow.png、error.png）导致的各种问题
* Fix various problems caused by pictures (right_arrow.png, left_arrow.png, error.png) on ​​iOS
## 1.0.7+3
* 临时修复 MethodChannel.Result 为 null 崩溃问题
* Temporarily fix crash when MethodChannel.Result is null
## 1.0.7+2
* 使用了sdk29，适配Android Q
* Used sdk29, adapted to Android Q
* 安卓修复小米Android Q 问题
* Android fixes Xiaomi Android Q issue
## 1.0.7+1
* 安卓修复安卓Q .gif 图片裁剪后无法播放的问题
* Android fix the problem that Android Q .gif picture cannot be played after cropping
## 1.0.7
* 新增保存图片ByteData数据
* Added Byte Data for saving pictures
* 修复iOS压缩图片异常
* Fix iOS compressed picture abnormal

## 1.0.6+2
* 修复flutter回调异常
* Fix flutter callback exception
* `CorpConfig` 类 改为 `CropConfig` 类，参数中的 `corpConfig` 改为 `cropConfig`
* `CorpConfig` class changed to` CropConfig` class, and `corpConfig` in the parameter was changed to` cropConfig`
* ios修复ios13获取图片路径没有后缀名问题，修复没有设置裁剪获取图片路径为null的问题
* ios fix ios 13 get image path without suffix

## 1.0.6+1
* ios修复ios13获取相册路径错误问题
* iOS fix iOS13 getting album path error problem
* android优化预览多图片时内存问题
* Android optimization memory issues when previewing multiple pictures
## 1.0.6
* 添加预览多图功能
* Add preview multi-picture function
* 修改ui主题颜色功能，由原来的预制ui颜色改为动态设置ui颜色
* Modify the ui theme color function from the original pre-made ui color to dynamically set the ui color
* 修复无法展示gif图片功能（注意：忽略了gif裁剪/压缩功能）
* Fix unable to display gif image function (note: gif crop/compress function is ignored)
## 1.0.5+3
* 安卓修复加载库报错问题
* Android fixes some mobile phone loading library error
## 1.0.5+2
* 修复项目主页重定向问题
* Fix project homepage redirection problem
## 1.0.5+1
* Modify bug
## 1.0.5
* 适配安卓安卓Q，增加ui主题配置功能，增加直接拍照和录制视频功能
* Adapt Android Android Q, add ui theme configuration function, increase direct photo and record video function
## 1.0.4+1
* Fix Android P can't preview image
## 1.0.4
* configuration description
## 1.0.3
* Increase the save network video to album function
## 1.0.2
* Support Android iOS
* Android i OS supports local language environment (Chinese or English)
* image_pickers Support picture selection, video multiple selection, support to save network pictures to albums, support preview video and preview picture function
