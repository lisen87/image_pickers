#import "ImagePickersPlugin.h"
#import <Photos/Photos.h>
//#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
//#import <ZLPhotoBrowser/ZLPhotoBrowser-umbrella.h>


#import "AKGallery.h"
#import "PlayTheVideoVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AFNetworking/AFNetworking.h>
#import "ChooseImageManager.h"
@import ZLPhotoBrowser.Swift;

#define Frame_rectStatus ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define Frame_rectNav (self.navigationController.navigationBar.frame.size.height)
#define Frame_NavAndStatus (self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height)
#define CXCHeightX   (([UIScreen mainScreen].bounds.size.height>=812.00)?([[UIScreen mainScreen] bounds].size.height-34):([[UIScreen mainScreen] bounds].size.height)/1.000)
#define CXCWeight    (([[UIScreen mainScreen] bounds].size.width)/1.000)
#define IsNilString(__String) (__String==nil ||[__String isEqual:[NSNull null]]|| [__String isEqualToString:@"null"] || [__String isEqualToString:@"<null>"]||[__String isEqualToString:@"(null)"]||[__String isEqualToString:@"null~null"]||[__String isEqualToString:@""])
@interface ImagePickersPlugin (){
    BOOL isShowGif;
}
@property(nonatomic, retain) FlutterMethodChannel *channel;

@end

@implementation ImagePickersPlugin
static NSString *const CHANNEL_NAME = @"flutter/image_pickers";

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME
                                                                binaryMessenger:[registrar messenger]];
    ImagePickersPlugin *instance = [[ImagePickersPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
        
}
-(UIColor*)stringChangeColor:(NSDictionary*)colorString{
    int alph =[[colorString objectForKey:@"a"] intValue];
    int red =[[colorString objectForKey:@"r"] intValue];
    int green =[[colorString objectForKey:@"g"] intValue];
    int blue =[[colorString objectForKey:@"b"] intValue];
    return [UIColor colorWithRed:red/255.00 green:green/255.00 blue:blue/255.00 alpha:alph/255.00];
}
-(void)colorChange:(NSDictionary*)colorString configuration:(ZLPhotoUIConfiguration*)configuration {
    UIColor* colorType =[self stringChangeColor:colorString];
    int light =[[colorString objectForKey:@"l"] intValue];
    /// 相册列表界面背景色
    [ZLPhotoUIConfiguration default].albumListBgColor =[UIColor whiteColor];
    [ZLPhotoUIConfiguration default].previewVCBgColor =[UIColor whiteColor];
    /// 分割线颜色
    [ZLPhotoUIConfiguration default].separatorColor =[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.98];
    /// 小图界面背景色
    [ZLPhotoUIConfiguration default].thumbnailBgColor =[UIColor whiteColor];
    /// 预览快速选择模式下 拍照/相册/取消 的背景颜色
    if(light<=179){
        /// 导航条颜色
        [ZLPhotoUIConfiguration default].navBarColor = colorType;
        /// 导航标题颜色
        [ZLPhotoUIConfiguration default].navTitleColor = [UIColor whiteColor];
        [ZLPhotoUIConfiguration default].navBarColorOfPreviewVC = colorType;
        ///  底部工具栏按钮 可交互 状态标题颜色
        [ZLPhotoUIConfiguration default].bottomToolViewBtnNormalTitleColor = [UIColor whiteColor];
        /// 底部工具栏按钮 可交互 状态背景颜色
        [ZLPhotoUIConfiguration default].bottomToolViewBtnNormalBgColor =colorType;
        /// 底部工具栏按钮 不可交互 状态背景颜色
        [ZLPhotoUIConfiguration default].bottomToolViewBtnDisableBgColor =colorType;
        [ZLPhotoUIConfiguration default].bottomToolViewBtnNormalBgColorOfPreviewVC =colorType;
        /// 自定义相机录制视频时，进度条颜色
        [ZLPhotoUIConfiguration default].cameraRecodeProgressColor =colorType;
        /// 选中图片右上角index background color
        [ZLPhotoUIConfiguration default].indexLabelBgColor =colorType;
        /// 底部工具条底色
        [ZLPhotoUIConfiguration default].bottomToolViewBgColor = colorType;
        //首页上部颜色
        [ZLPhotoUIConfiguration default].navEmbedTitleViewBgColor = colorType;
    }else{
        /// 导航条颜色
        [ZLPhotoUIConfiguration default].navBarColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        /// 导航标题颜色
        [ZLPhotoUIConfiguration default].navTitleColor = [UIColor blackColor];
        [ZLPhotoUIConfiguration default].navBarColorOfPreviewVC = [UIColor blackColor];
        /// 底部工具栏按钮 可交互 状态背景颜色
        [ZLPhotoUIConfiguration default].bottomToolViewBtnNormalBgColor =[UIColor blackColor];
        /// 底部工具栏按钮 不可交互 状态背景颜色
        [ZLPhotoUIConfiguration default].bottomToolViewBtnDisableBgColor =[UIColor blackColor];
        /// 自定义相机录制视频时，进度条颜色
        [ZLPhotoUIConfiguration default].cameraRecodeProgressColor =[UIColor blackColor];
        /// 选中图片右上角index background color
        [ZLPhotoUIConfiguration default].indexLabelBgColor =[UIColor blackColor];
        /// 底部工具条底色
        [ZLPhotoUIConfiguration default].bottomToolViewBgColor = [UIColor whiteColor];
        ///首页上部颜色
        [ZLPhotoUIConfiguration default].navEmbedTitleViewBgColor = [UIColor whiteColor];
    }
    /// 相册列表界面 相册title颜色
    [ZLPhotoUIConfiguration default].albumListTitleColor = [UIColor blackColor];
    [ZLPhotoUIConfiguration default].navViewBlurEffectOfPreview =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [ZLPhotoUIConfiguration default].navViewBlurEffectOfAlbumList =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [ZLPhotoUIConfiguration default].bottomViewBlurEffectOfPreview =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [ZLPhotoUIConfiguration default].bottomViewBlurEffectOfAlbumList =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
}
-(void)changeLanguage:(NSString*)language{
    
    if(!IsNilString(language)){
        ///设置语言
        if([language isEqualToString:@"system"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeSystem;
        }else if ([language isEqualToString:@"chinese"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeChineseSimplified;

        }else if ([language isEqualToString:@"traditional_chinese"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeChineseTraditional;

        }else if ([language isEqualToString:@"english"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeEnglish;

        }else if ([language isEqualToString:@"japanese"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeJapanese;

        }else if ([language isEqualToString:@"france"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeFrench;

        }else if ([language isEqualToString:@"german"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeGerman;

        }else if ([language isEqualToString:@"russian"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeRussian;

        }else if ([language isEqualToString:@"vietnamese"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeVietnamese;

        }else if ([language isEqualToString:@"korean"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeKorean;

        }else if ([language isEqualToString:@"portuguese"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypePortuguese;

        }else if ([language isEqualToString:@"spanish"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeSpanish;

        }else if ([language isEqualToString:@"arabic"]){
            [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeArabic;

        }
        
    }else{
        [ZLPhotoUIConfiguration default].languageType=ZLLanguageTypeSystem;

    }
}
-(void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSDictionary *callDic = call.arguments;
    NSString*language =[NSString stringWithFormat:@"%@",callDic[@"language"]];
    [self changeLanguage:language];
   
    resultBack =result;
    if([@"getPickerPaths" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        NSInteger selectCount =[[dic objectForKey:@"selectCount"] integerValue];//最多多少个
        NSInteger compressSize =[[dic objectForKey:@"compressSize"] integerValue]*1024;//大小
        NSString *galleryMode =[NSString stringWithFormat:@"%@",[dic objectForKey:@"galleryMode"]];//图片还是视频image video all
        BOOL enableCrop =[[dic objectForKey:@"enableCrop"] boolValue];//是否裁剪
        NSInteger height =[[dic objectForKey:@"height"] integerValue];//宽高比例
        NSInteger width =[[dic objectForKey:@"width"] integerValue];//宽高比例
        if(width<=0||height<=0){
            width=0;
            height=1;
        }
        BOOL showCamera =[[dic objectForKey:@"showCamera"] boolValue];//显示摄像头
        isShowGif =[[dic objectForKey:@"showGif"] boolValue];//是否选择gif

        //type photo video  若不存在则为带相册的，若存在则直接打开相册相机
        NSString *cameraMimeType =[dic objectForKey:@"cameraMimeType"];
        ZLPhotoConfiguration *configuration =[ZLPhotoConfiguration default];
        configuration.maxSelectCount = selectCount;//最多选择多少张图
        configuration.allowTakePhotoInLibrary =showCamera;//是否显示摄像头
        configuration.allowSelectOriginal =NO;//不选择原图
        configuration.downloadVideoBeforeSelecting =true;//选择之前下载
        configuration.timeout =600;
        [ZLPhotoUIConfiguration default].cellCornerRadio =5;
        configuration.allowSelectGif = isShowGif;
          
        //type photo video  若不存在则为带相册的，若存在则直接打开相机或录像
          if([cameraMimeType isEqualToString:@"video"]||[galleryMode isEqualToString:@"video"]||[galleryMode isEqualToString:@"all"]){
                   if([dic objectForKey:@"videoRecordMinSecond"]){
                       NSInteger videoRecordMinSecond =[[dic objectForKey:@"videoRecordMinSecond"] integerValue];

                       [ZLPhotoConfiguration default].cameraConfiguration.minRecordDuration =videoRecordMinSecond;
                   }
                   if([dic objectForKey:@"videoSelectMinSecond"]){
                       NSInteger videoSelectMinSecond =[[dic objectForKey:@"videoSelectMinSecond"] integerValue];

                       configuration.minSelectVideoDuration = videoSelectMinSecond;
                   }
                   if([dic objectForKey:@"videoRecordMaxSecond"]){
                       NSInteger videoRecordMaxSecond =[[dic objectForKey:@"videoRecordMaxSecond"] integerValue];

                       [ZLPhotoConfiguration default].cameraConfiguration.maxRecordDuration =videoRecordMaxSecond;
                   }
                   if([dic objectForKey:@"videoSelectMaxSecond"]){
                       NSInteger videoSelectMaxSecond =[[dic objectForKey:@"videoSelectMaxSecond"] integerValue];

                       configuration.maxSelectVideoDuration = videoSelectMaxSecond;
                   }
         }

        /*以下是编辑相关*/
        ///如果是可编辑的就需要设置editAfterSelectThumbnailImage 因为editAfterSelectThumbnailImage=true和maxSelectCount=1的时候enableCrop=false ，所以需要editAfterSelectThumbnailImage =false
        configuration.allowEditImage =enableCrop;
        if(enableCrop==true&&selectCount==1){
            configuration.editAfterSelectThumbnailImage =false;
        }else{
            configuration.editAfterSelectThumbnailImage =true;
        }
        configuration.editImageConfiguration.tools_objc=@[@1];
        configuration.editImageConfiguration.clipRatios=@[[[ZLImageClipRatio alloc]initWithTitle:@"" whRatio:((float)width/(float)height) isCircle:false]];
        ZLPhotoUIConfiguration *configurationUI =[ZLPhotoUIConfiguration default];
        [self colorChange:[dic objectForKey:@"uiColor"] configuration:configurationUI];
        //拍照或者视频的时候
        if(cameraMimeType) {
            /*以下是图片和视频混合选择相关*/
            if ([cameraMimeType isEqual:@"photo"]){
                configuration.allowMixSelect = false;//不允许混合选择
                [ZLPhotoConfiguration default].cameraConfiguration.allowTakePhoto = YES;
                [ZLPhotoConfiguration default].cameraConfiguration.allowRecordVideo = NO;
                configuration.allowSelectImage =YES;
                configuration.allowSelectVideo =NO;
             
            }else if([cameraMimeType isEqual:@"video"]){
                configuration.allowMixSelect = true;//允许混合选择 不允许的时候只能选一个所以这里写允许
                [ZLPhotoConfiguration default].cameraConfiguration.allowRecordVideo = YES;
                [ZLPhotoConfiguration default].cameraConfiguration.allowTakePhoto = NO;
                configuration.allowSelectVideo =YES;
                configuration.allowSelectImage =NO;
        
            }
            
            ZLCustomCamera *camera = [[ZLCustomCamera alloc] init];
            [[UIApplication sharedApplication].delegate.window.rootViewController  showDetailViewController:camera sender:nil];
            camera.takeDoneBlock = ^(UIImage *image, NSURL *videoUrl){
                NSLog(@"%@",videoUrl);
                NSLog(@"%@",image);
                if (image) {
                    NSData *data2=UIImageJPEGRepresentation(image , 1);
                    float size =1.0;
                    if (data2.length>compressSize) {
                        size =  (float)compressSize/(float)data2.length;
                    }
                    data2=UIImageJPEGRepresentation(image, size);
                    UIImage *imageFF =[UIImage imageWithData:data2];
                    //重命名并且保存
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    int  x = arc4random() % 10000;
                    NSString *name = [NSString stringWithFormat:@"%@01%d",[formatter stringFromDate:[NSDate date]],x];
                    NSString  *jpgPath = [NSHomeDirectory()  stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.%@",name,[self imageType:data2]]];
                    //保存到沙盒
                    [UIImageJPEGRepresentation(imageFF,1) writeToFile:jpgPath atomically:YES];
                    NSDictionary *photoDic =@{
                        @"thumbPath":[NSString stringWithFormat:@"%@",jpgPath],
                        @"path":[NSString stringWithFormat:@"%@",jpgPath],
                    };
                    //取出路径
                    NSArray *arr =@[photoDic];
                    result(arr);
                    return ;
                }else{

                    NSURL *url =videoUrl;
                    NSString *subString = [url.absoluteString substringFromIndex:7];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    int  x = arc4random() % 10000;
                    NSString *name = [NSString stringWithFormat:@"%@%d",[formatter stringFromDate:[NSDate date]],x];
                    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
                    UIImage *img = [self getImage:subString];
                    NSData *data2=UIImageJPEGRepresentation(img , 1);
                    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(),name,[self imageType:data2]];
                    [UIImageJPEGRepresentation(img,1) writeToFile:aPath3 atomically:YES];

                    NSDictionary *photoDic = @{
                        @"thumbPath":[NSString stringWithFormat:@"%@",aPath3],
                        @"path":[NSString stringWithFormat:@"%@",subString],
                    };
                    NSArray *arr =@[photoDic];
                    result(arr);
                    return ;
                }
            };

        }else{
            ZLPhotoPreviewSheet *ac = [[ZLPhotoPreviewSheet alloc] init];
            /*以下是图片和视频混合选择相关*/
            if([galleryMode isEqual:@"all"]){
                configuration.allowMixSelect = true;//允许混合选择
                [ZLPhotoConfiguration default].cameraConfiguration.allowRecordVideo = YES;
                [ZLPhotoConfiguration default].cameraConfiguration.allowTakePhoto = YES;
                configuration.allowSelectImage =YES;
                configuration.allowSelectVideo =YES;
                
            }else if ([galleryMode isEqual:@"image"]){
                configuration.allowMixSelect = false;//不允许混合选择
                [ZLPhotoConfiguration default].cameraConfiguration.allowTakePhoto = YES;
                [ZLPhotoConfiguration default].cameraConfiguration.allowRecordVideo = NO;
                configuration.allowSelectImage =YES;
                configuration.allowSelectVideo =NO;
             
            }else if([galleryMode isEqual:@"video"]){
                configuration.allowMixSelect = true;//允许混合选择 不允许的时候只能选一个所以这里写允许
                [ZLPhotoConfiguration default].cameraConfiguration.allowRecordVideo = YES;
                [ZLPhotoConfiguration default].cameraConfiguration.allowTakePhoto = NO;
                configuration.allowSelectVideo =YES;
                configuration.allowSelectImage =NO;
            }
            
            ///区分是从icloud上的。暂时发现iCloud的有问题
//            configuration.canSelectAsset = ^BOOL(PHAsset * asset) {
//                if(asset.sourceType==PHAssetSourceTypeCloudShared){
//                    return  false;
//                }
//                return true;
//            };
        
            NSMutableArray *arr11 =[[NSMutableArray alloc]init];
            ac.cancelBlock = ^{
                NSArray *arr =@[];
                result(arr);
            };
            ac.selectImageBlock = ^(NSArray<ZLResultModel *> * modelList, BOOL isB) {
                if (modelList.count>0) {
                    
                    [self saveImageView:0 imagePHAsset:modelList arr:arr11  compressSize:compressSize result:(FlutterResult)result];
                }
            };
            [ac showPhotoLibraryWithSender:[UIApplication sharedApplication].delegate.window.rootViewController];
        }

    } else if ([@"previewImages" isEqualToString:call.method]){

        NSDictionary *dic = call.arguments;
        NSMutableArray *arr =[[NSMutableArray alloc]init];
        NSArray *imageArr =[dic objectForKey:@"paths"];
        NSInteger initIndex =[[dic objectForKey:@"initIndex"] intValue];
        NSArray* videoSuffixs = @[@"mp4", @"mov", @"avi", @"rmvb", @"rm", @"flv", @"3gp", @"wmv", @"vob", @"dat", @"m4v", @"f4v", @"mkv"]; // and mor
        for (int i=0; i<imageArr.count; i++) {
            NSString *imgString  =imageArr[i];
           if ([[NSString stringWithFormat:@"%@",imgString] containsString:@"http"]||[imgString containsString:@"GIF"]||[[NSString stringWithFormat:@"%@",imgString] containsString:@"gif"]) {
               if([videoSuffixs containsObject: [imgString componentsSeparatedByString:@"."].lastObject.lowercaseString]){
                   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                   formatter.dateFormat = @"yyyyMMddHHmmss";
                   int  x = arc4random() % 10000;
                   NSString *name = [NSString stringWithFormat:@"%@%d",[formatter stringFromDate:[NSDate date]],x];
                   UIImage *img = [self getUrlImage:imgString];
                   NSData *data2=UIImageJPEGRepresentation(img , 1);
                   NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(),name,[self imageType:data2]];
                BOOL isSave= [UIImageJPEGRepresentation(img,1) writeToFile:aPath3 atomically:YES];
                   AKGalleryItem* item = [AKGalleryItem itemWithTitle:@"" url:nil img:img videoString:imgString];
                   [arr addObject:item];
               }else{
                   AKGalleryItem* item = [AKGalleryItem itemWithTitle:@"" url:[NSString stringWithFormat:@"%@",imgString] img:nil videoString:@""];
                   [arr addObject:item];
               }

            }else if ([[NSString stringWithFormat:@"%@",imgString] containsString:@"var/"]||[[NSString stringWithFormat:@"%@",imgString] containsString:@"CoreSimulator/"]){
                if([videoSuffixs containsObject: [imgString componentsSeparatedByString:@"."].lastObject.lowercaseString]){
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    int  x = arc4random() % 10000;
                    NSString *name = [NSString stringWithFormat:@"%@%d",[formatter stringFromDate:[NSDate date]],x];
                   
                    UIImage *img = [self getImage:imgString];
                    NSData *data2=UIImageJPEGRepresentation(img , 1);
                    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(),name,[self imageType:data2]];
                 BOOL isSave= [UIImageJPEGRepresentation(img,1) writeToFile:aPath3 atomically:YES];
                    AKGalleryItem* item = [AKGalleryItem itemWithTitle:@"" url:nil img:img videoString:imgString];
                    [arr addObject:item];
                    
                }else{
                    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@",imgString]]];
                    AKGalleryItem* item = [AKGalleryItem itemWithTitle:@"" url:nil img:image videoString:@""];
                    [arr addObject:item];
                }
           
            }
            if (i==imageArr.count-1) {
                AKGallery* gallery = AKGallery.new;
                gallery.items=arr;
                gallery.modalPresentationStyle = 0;
                gallery.custUI=AKGalleryCustUI.new;
                gallery.selectIndex=initIndex;
                gallery.completion=^{
                };
                //show gallery
                gallery.modalPresentationStyle =UIModalPresentationFullScreen;
                [[UIApplication sharedApplication].delegate.window.rootViewController presentAKGallery:gallery animated:YES completion:nil];
            }
        }
    }else if ([@"previewImage" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        NSMutableArray *arr =[[NSMutableArray alloc]init];
        BOOL isOnline =false;///默认是本地
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]] containsString:@"http"]) {
            isOnline =true;
        }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]] containsString:@"var/"]||[[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]] containsString:@"CoreSimulator/"]){
            isOnline =false;
        }else{
            return;
        }
        AKGalleryItem* item = [AKGalleryItem itemWithTitle:@"" url:isOnline==true?([NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]]):nil img:isOnline==true?nil:([UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]]]] ) videoString:@""];
        [arr addObject:item];
        AKGallery* gallery = AKGallery.new;
        gallery.items=arr;
        gallery.custUI=AKGalleryCustUI.new;
        gallery.selectIndex=0;
        gallery.completion=^{
        };
        gallery.modalPresentationStyle =UIModalPresentationFullScreen;
        [[UIApplication sharedApplication].delegate.window.rootViewController presentAKGallery:gallery animated:YES completion:nil];

    }else if ([@"previewVideo" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        PlayTheVideoVC *vc =[[PlayTheVideoVC alloc]init];
        vc.modalPresentationStyle=0;
        vc.videoUrl =[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]];
        vc.modalPresentationStyle =UIModalPresentationFullScreen;
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:vc animated:YES completion:^{

        }];

    }else if ([@"saveByteDataImageToGallery" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        FlutterStandardTypedData *data =[dic objectForKey:@"uint8List"];
        UIImage *image=[UIImage imageWithData:data.data];
        __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error){
            NSString *str =assetURL.absoluteString;
            NSString *string =@"://";
            NSRange range = [str rangeOfString:string];//匹配得到的下标
            if(range.location+range.length<str.length){
                str = [str substringFromIndex:range.location+range.length];
                if (error) {

                }else{
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *string;
                    NSString *subStr = @"&ext=";//指定字符串
                    if ([str containsString:subStr])
                    {//先做安全判断
                        NSRange subStrRange = [str rangeOfString:subStr];//找出指定字符串的range
                        NSInteger index = subStrRange.location + subStrRange.length;//获得“指定的字符以后的所有字符”的起始点
                        NSString *restStr = [str substringFromIndex:index];
                        string =restStr;
                    }else{
                        string =@"png";
                    }
                    NSString *name = [NSString stringWithFormat:@"%@01.%@",[formatter stringFromDate:[NSDate date]],string];

                    NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
                    //保存到沙盒
                    [UIImageJPEGRepresentation(image,1.0) writeToFile:jpgPath atomically:YES];
                    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),name];

                    result(aPath3);
                }
            }

        }];

    }
    else if([@"saveImageToGallery" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        NSString *url =[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]];
        if ([url.lastPathComponent containsString:@"gif"]||[url.lastPathComponent containsString:@"GIF"]) {

            [self saveGifImage:url];
        }else{
            UIImage *img =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
            [lib writeImageToSavedPhotosAlbum:img.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
             {
                NSString *str =assetURL.absoluteString;
                NSString *string =@"://";
                NSRange range = [str rangeOfString:string];//匹配得到的下标
                if(range.location+range.length<str.length){
                    str = [str substringFromIndex:range.location+range.length];
                    if (error) {

                    }else{
                        result([NSString stringWithFormat:@"/%@",str]);
                    }
                }
            }];
        }
    }else if([@"saveVideoToGallery" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        NSString *urlString =[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]];
        [self  playerDownload :urlString];
    }
}

-(void)saveImageView:(NSInteger)index imagePHAsset:(NSArray<ZLResultModel *> *)modelList arr:(NSMutableArray*)arr compressSize:(NSInteger)compressSize result:(FlutterResult)result{
   
    if (index==modelList.count) {
        NSMutableArray *urlArr =[[NSMutableArray alloc]init];
        for (int i=0; i<arr.count; i++) {
            NSDictionary *photoDic =arr[i];
            [urlArr addObject:photoDic];
        }
        result(urlArr);
        return ;
    }
    PHAsset *asset  =modelList[index].asset;
    index++;
    if(asset.mediaType==PHAssetMediaTypeVideo){

        //视频
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        PHImageManager *manager = [PHImageManager defaultManager];
        options.networkAccessAllowed =YES;

        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {

            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            NSURL *url = urlAsset.URL;
            NSString *subString = [url.absoluteString substringFromIndex:7];
//            NSInteger a=  urlAsset.duration.value/urlAsset.duration.timescale;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            int  x = arc4random() % 10000;
            NSString *name = [NSString stringWithFormat:@"%@%d",[formatter stringFromDate:[NSDate date]],x];
            NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
            UIImage *img = [self getImage:subString]  ;
            //保存到沙盒
            [UIImageJPEGRepresentation(img,1.0) writeToFile:jpgPath atomically:YES];
            NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),name];
            [arr addObject:@{
                @"thumbPath":[NSString stringWithFormat:@"%@",aPath3],
                @"path":[NSString stringWithFormat:@"%@",subString],
            }];
            [self saveImageView:index imagePHAsset:modelList arr:arr  compressSize:compressSize result:result];
          
        }];
        
    }else if(asset.mediaType==PHAssetMediaTypeImage){
        PHImageManager *manage =[[PHImageManager alloc]init];
        PHImageRequestOptions *option =[[PHImageRequestOptions alloc]init];
        option.networkAccessAllowed = YES;
        [manage requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *im =[UIImage imageWithData:imageData];
            NSURL * path = [info objectForKey:@"PHImageFileURLKey"];
            NSString *str =path.absoluteString;
            NSString *imageLast = [str lastPathComponent];
            if (!path) {
                imageLast =[NSString stringWithFormat:@"%ld.%@",imageData.length,[dataUTI pathExtension]];
                ;
            }
            if((![dataUTI containsString:@"gif"])&&(![dataUTI containsString:@"GIF"])){
                //若裁剪需要裁剪后的图片，需要保存一下
                //重命名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *name = [NSString stringWithFormat:@"%@%@",[formatter stringFromDate:[NSDate date]],imageLast];
                NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
                NSData *data2=UIImageJPEGRepresentation(im , 1.0);
                float rate =1.0;
                if (data2.length>compressSize) {
                    rate =  (float)compressSize/(float)data2.length;
                }
                NSData* data=  UIImageJPEGRepresentation(im,rate);
                //保存到沙盒
                [data writeToFile:jpgPath atomically:YES];
                //取出路径
                [arr addObject: @{
                    @"thumbPath":[NSString stringWithFormat:@"%@",jpgPath],
                    @"path":[NSString stringWithFormat:@"%@",jpgPath],
                }];
                [self saveImageView:index imagePHAsset:modelList arr:arr  compressSize:compressSize result:result];
            }else{
                NSData *gifData = imageData;
                NSString *str = [ImagePickersPlugin createFile:gifData suffix:@".gif"];
                //取出路径
                [arr addObject: @{
                    @"thumbPath":[NSString stringWithFormat:@"%@",str],
                    @"path":[NSString stringWithFormat:@"%@",str],
                }];
                [self saveImageView:index imagePHAsset:modelList arr:arr  compressSize:compressSize result:result];
            }
      
            
        }];
    }
}
#pragma mark //保存gif
- (void)saveGifDataImage:(NSData*)data {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:nil];
    }completionHandler:^(BOOL success,NSError*_Nullableerror) {
        if(success && !_Nullableerror) {
            NSLog(@"下载成功");
        }else{
            NSLog(@"下载失败");
        }
    }];
}
- (void)saveGifImage:(NSString*)urlString {
    
    NSURL *fileUrl = [NSURL URLWithString:urlString];
    
    [[[NSURLSession sharedSession] downloadTaskWithURL:fileUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
        NSData *data = [NSData dataWithContentsOfFile:location.path];
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:nil];
            
        }completionHandler:^(BOOL success,NSError*_Nullableerror) {
            if(success && !error) {
                NSLog(@"下载成功");
            }else{
                NSLog(@"下载失败");
            }
        }];
    }]resume];
    
}

#pragma mark 通过视频的路径获取视频的第一帧
-(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}
#pragma mark 通过网络视频获取视频的第一帧

-(UIImage *)getUrlImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

///下载视频
- (void)playerDownload:(NSString *)url{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory,[NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]]];
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:fullPath];
    }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@",response);
        [self saveVideo:fullPath];
    }];
    [task resume];
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {   //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}
//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
        resultBack(@"fail");
    }
    else {
        NSLog(@"保存视频成功");
        resultBack(@"success");
        
    }
}

+ (NSString *)createFile:(NSData *)data suffix:(NSString *)suffix {
    NSString *tmpPath = [self temporaryFilePath:suffix];
    if ([[NSFileManager defaultManager] createFileAtPath:tmpPath contents:data attributes:nil]) {
        return tmpPath;
    } else {
        nil;
    }
    return tmpPath;
}
+ (NSString *)temporaryFilePath:(NSString *)suffix {
    NSString *fileExtension = [@"image_picker_%@" stringByAppendingString:suffix];
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *tmpFile = [NSString stringWithFormat:fileExtension, guid];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *tmpPath = [tmpDirectory stringByAppendingPathComponent:tmpFile];
    return tmpPath;
}
-(NSString*)imageType:(NSData*)data{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"JPEG";
        case 0x89:
            return @"PNG";
        case 0x47:
            return @"GIF";
        case 0x49:
        case 0x4D:
            return @"PNG";
        case 0x52: {
            return @"PNG";
        }
        case 0x00: {
            return @"PNG";
        }
        default:
            return @"PNG";
    }
    return @"PNG";
}
@end
