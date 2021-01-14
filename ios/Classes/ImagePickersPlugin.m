#import "ImagePickersPlugin.h"
#import <Photos/Photos.h>

#if __has_include(<ZLPhotoBrowser_objc/ZLPhotoBrowser.h>)
#import <ZLPhotoBrowser_objc/ZLPhotoBrowser.h>
#else
#import "ZLPhotoBrowser.h"
#endif

#import "AKGallery.h"
#import "PlayTheVideoVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AFNetworking/AFNetworking.h>
#import "BigImageViewController.h"
#define Frame_rectStatus ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define Frame_rectNav (self.navigationController.navigationBar.frame.size.height)
#define Frame_NavAndStatus (self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height)
#define CXCHeightX   ( ([UIScreen mainScreen].bounds.size.height>=812.00)?([[UIScreen mainScreen] bounds].size.height-34):([[UIScreen mainScreen] bounds].size.height)/1.000)
#define CXCWeight   ( ([[UIScreen mainScreen] bounds].size.width)/1.000)
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
    int light =[[colorString objectForKey:@"l"] intValue];
    return [UIColor colorWithRed:red/255.00 green:green/255.00 blue:blue/255.00 alpha:alph/255.00];
}
-(void)colorChange:(NSDictionary*)colorString configuration:(ZLPhotoConfiguration*)configuration {
    UIColor* colorType =[self stringChangeColor:colorString];
    int light =[[colorString objectForKey:@"l"] intValue];
    
    if(light<=179){
        configuration. bottomBtnsDisableBgColor =[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];//未选中按钮
        configuration.bottomBtnsNormalBgColor =colorType;//选中
        configuration.indexLabelBgColor =colorType;//数字背景
        configuration.cameraProgressColor =colorType;//进度
        configuration.navBarColor =colorType;//导航栏
        configuration.navTitleColor =[UIColor whiteColor];//导航元素
    }else{
        configuration. bottomBtnsDisableBgColor =[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        configuration.bottomBtnsNormalBgColor =[UIColor blackColor];
        configuration.indexLabelBgColor =[UIColor blackColor];
        configuration.cameraProgressColor =[UIColor blackColor];
        configuration.navBarColor =[UIColor whiteColor];
        configuration.navTitleColor =[UIColor blackColor];
    }
}
-(void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    resultBack =result;
    if([@"getPickerPaths" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        NSInteger selectCount =[[dic objectForKey:@"selectCount"] integerValue];//最多多少个
        NSInteger compressSize =[[dic objectForKey:@"compressSize"] integerValue]*1024;//大小
        
        NSString *galleryMode =[NSString stringWithFormat:@"%@",[dic objectForKey:@"galleryMode"]];//图片还是视频image video
        
        BOOL enableCrop =[[dic objectForKey:@"enableCrop"] boolValue];//是否裁剪
        
        NSInteger height =[[dic objectForKey:@"height"] integerValue];//宽高比例
        
        NSInteger width =[[dic objectForKey:@"width"] integerValue];//宽高比例
        
        
        BOOL showCamera =[[dic objectForKey:@"showCamera"] boolValue];//显示摄像头
        isShowGif =[[dic objectForKey:@"showGif"] boolValue];//是否选择gif
        
        NSString *cameraMimeType =[dic objectForKey:@"cameraMimeType"];//type   photo video 若不存在则为带相册的，若存在则直接打开相册相机
        
        ZLPhotoConfiguration *configuration =[ZLPhotoConfiguration defaultPhotoConfiguration];
        configuration.maxSelectCount = selectCount;//最多选择多少张图
        configuration.mutuallyExclusiveSelectInMix = NO;//不允许混合选择
        configuration.allowTakePhotoInLibrary =showCamera;//是否显示摄像头
        configuration.allowSelectOriginal =NO;//不选择原图
        configuration.allowEditImage =enableCrop;
        configuration.hideClipRatiosToolBar =enableCrop;
        configuration.cellCornerRadio =30;
        configuration.clipRatios =@[@{
                                        @"value1":[NSNumber numberWithInt:width],//第一个是宽
                                        @"value2":[NSNumber numberWithInt:height],//第二个是高
        }];

        if(cameraMimeType) {
            //            cameraMimeType//type   photo video

            [self colorChange:[dic objectForKey:@"uiColor"] configuration:configuration];
            ZLCustomCamera *camera = [[ZLCustomCamera alloc] init];
            
            if ([cameraMimeType isEqualToString:@"photo"]) {
                camera.allowTakePhoto = YES;
                camera.allowRecordVideo = NO;
            }else{
                camera.allowTakePhoto = NO;
                camera.allowRecordVideo = YES;
            }

            camera.videoType = ZLExportVideoTypeMp4;
            camera.circleProgressColor = [UIColor redColor];
            camera.maxRecordDuration = 15;
            @zl_weakify(self);
            
            camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {

                NSLog(@"%@",videoUrl);

                NSLog(@"%@",image);
                
                if (image) {
                    if(enableCrop){
                        BigImageViewController *big =[[BigImageViewController alloc]init];
                        big.configuration =configuration ;
                        big.image =image;
                        big.doneEditImageBlock = ^(UIImage * imageE) {
                            NSData *data2=UIImageJPEGRepresentation(imageE , 1.0);
                            if (data2.length>compressSize) {
                                //压缩
                                data2=UIImageJPEGRepresentation(imageE, (float)(compressSize/data2.length));
                            }
                            NSLog(@"_____方法__%ld",data2.length);
                            UIImage *image =[UIImage imageWithData:data2];
                            //重命名并且保存
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            formatter.dateFormat = @"yyyyMMddHHmmss";
                            int  x = arc4random() % 10000;

                            NSString *name = [NSString stringWithFormat:@"%@01%d",[formatter stringFromDate:[NSDate date]],x];
                            NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.%@",name,[self imageType:data2]]];

                            //保存到沙盒
                            [UIImageJPEGRepresentation(image,1.0) writeToFile:jpgPath atomically:YES];
                            NSDictionary *photoDic =@{
                                @"thumbPath":[NSString stringWithFormat:@"%@",jpgPath],
                                @"path":[NSString stringWithFormat:@"%@",jpgPath],
                            };
                            //取出路径
                            result(@[photoDic]);
                            return ;

                        };
                        big.modalPresentationStyle =UIModalPresentationFullScreen;

                        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:big animated:YES completion:^{
                        }];
                    }else{
                        NSData *data2=UIImageJPEGRepresentation(image , 1.0);
                        if (data2.length>compressSize) {
                            //压缩
                            data2=UIImageJPEGRepresentation(image, (float)(compressSize/data2.length));
                        }
                        NSLog(@"_____方法__%ld",data2.length);
                        UIImage *imageFF =[UIImage imageWithData:data2];
                        //重命名并且保存
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyyMMddHHmmss";
                        int  x = arc4random() % 10000;

                        NSString *name = [NSString stringWithFormat:@"%@01%d",[formatter stringFromDate:[NSDate date]],x];
                        NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.%@",name,[self imageType:data2]]];

                        //保存到沙盒
                        [UIImageJPEGRepresentation(imageFF,1.0) writeToFile:jpgPath atomically:YES];
                        NSDictionary *photoDic =@{
                            @"thumbPath":[NSString stringWithFormat:@"%@",jpgPath],
                            @"path":[NSString stringWithFormat:@"%@",jpgPath],
                        };
                        //取出路径
                        result(@[photoDic]);
                        return ;

                    }
                    
                    

                }else{


                    NSURL *url =videoUrl;
                    NSString *subString = [url.absoluteString substringFromIndex:7];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    int  x = arc4random() % 10000;
                    NSString *name = [NSString stringWithFormat:@"%@%d",[formatter stringFromDate:[NSDate date]],x];
                    NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
                    UIImage *img = [self getImage:subString]  ;
                    //保存到沙盒
                    [UIImageJPEGRepresentation(img,1.0) writeToFile:jpgPath atomically:YES];
                    NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),name];

                    NSDictionary *photoDic = @{
                        @"thumbPath":[NSString stringWithFormat:@"%@",aPath3],
                        @"path":[NSString stringWithFormat:@"%@",subString],
                    };
                    result(@[photoDic]);
                    return ;
                    
                }
                
            };
            camera.modalPresentationStyle =UIModalPresentationFullScreen;
            [[UIApplication sharedApplication].delegate.window.rootViewController showDetailViewController:camera sender:nil];

        }else{
            
            ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
            ac.configuration.maxSelectCount = selectCount;//最多选择多少张图
            ac.configuration.mutuallyExclusiveSelectInMix = NO;//不允许混合选择
            ac.configuration.allowTakePhotoInLibrary =showCamera;//是否显示摄像头
            ac.configuration.allowSelectOriginal =NO;//不选择原图
            ac.configuration.allowEditImage =enableCrop;
            ac.configuration.hideClipRatiosToolBar =enableCrop;
            ac.configuration.clipRatios =@[@{
                                               @"value1":[NSNumber numberWithInt:width],//第一个是宽
                                               @"value2":[NSNumber numberWithInt:height],//第二个是高
            }];
            ac.configuration.allowSelectGif = isShowGif;
            
            if ([galleryMode isEqualToString:@"image"]) {
                ac.configuration. allowSelectImage =YES;
                ac.configuration.allowSelectVideo =NO;
            }else{
                ac.configuration. allowSelectImage =NO;
                ac.configuration.allowSelectVideo =YES;
            }
            
            //        ac.configuration.shouldAnialysisAsset = YES;
            //框架语言
            //        ac.configuration.languageType = YES;
            //如调用的方法无sender参数，则该参数必传
            ac.sender = [UIApplication sharedApplication].delegate.window.rootViewController;
            [self colorChange:[dic objectForKey:@"uiColor"] configuration:ac.configuration];
            
            NSMutableArray *arr =[[NSMutableArray alloc]init];
            
            [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
                //your codes
                if (![galleryMode isEqualToString:@"image"]) {
                    
                    for (NSInteger i = 0; i < assets.count; i++) {
                        // 获取一个资源（PHAsset）
                        PHAsset *phAsset = assets[i];
                        PHImageManager *manage =[[PHImageManager alloc]init];
                        PHImageRequestOptions *option =[[PHImageRequestOptions alloc]init];
                        //视频
                        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                        options.version = PHImageRequestOptionsVersionCurrent;
                        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                        PHImageManager *manager = [PHImageManager defaultManager];
                        [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                            
                            AVURLAsset *urlAsset = (AVURLAsset *)asset;
                            NSURL *url = urlAsset.URL;
                            NSString *subString = [url.absoluteString substringFromIndex:7];
                            
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            formatter.dateFormat = @"yyyyMMddHHmmss";
                            int  x = arc4random() % 10000;
                            NSString *name = [NSString stringWithFormat:@"%@%d",[formatter stringFromDate:[NSDate date]],x];
                            NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
                            UIImage *img = [self getImage:subString]  ;
                            //保存到沙盒
                            [UIImageJPEGRepresentation(img,1.0) writeToFile:jpgPath atomically:YES];
                            NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),name];
                            
                            //取出路径
                            [arr addObject:@{
                                @"thumbPath":[NSString stringWithFormat:@"%@",aPath3],
                                @"path":[NSString stringWithFormat:@"%@",subString],
                            }];
                            //NSLog(@"%@",arr);
                            if (arr.count==assets.count) {
                                result(arr);
                                return ;
                                
                            }
                            
                        }];
                    }
                }else{
                    
                    if (assets.count>0) {
                        [self saveImageView:0 imagePHAsset:assets arr:arr  compressSize:compressSize result:(FlutterResult)result];
                        
                    }
                    
                }
                
                //        [self zhuanhuanTupian];
                
            }];
            [ac showPhotoLibrary];
        }
        
    } else if ([@"previewImages" isEqualToString:call.method]){
        
        NSDictionary *dic = call.arguments;
        NSMutableArray *arr =[[NSMutableArray alloc]init];
        
        NSArray *imageArr =[dic objectForKey:@"paths"];
        NSInteger initIndex =[[dic objectForKey:@"initIndex"] intValue];
        
        for (int i=0; i<imageArr.count; i++) {
            NSString *imgString  =imageArr[i];
            if ([[NSString stringWithFormat:@"%@",imgString] containsString:@"http"]||[imgString containsString:@"GIF"]||[[NSString stringWithFormat:@"%@",imgString] containsString:@"gif"]) {
                AKGalleryItem* item = [AKGalleryItem itemWithTitle:@"图片详情" url:[NSString stringWithFormat:@"%@",imgString] img:nil];
                [arr addObject:item];
                
            }else if ([[NSString stringWithFormat:@"%@",imgString] containsString:@"var/"]||[[NSString stringWithFormat:@"%@",imgString] containsString:@"CoreSimulator/"]){
                
                UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@",imgString]]];
                AKGalleryItem* item = [AKGalleryItem itemWithTitle:@"图片详情" url:nil img:image];
                [arr addObject:item];
            }
            if (i==imageArr.count-1) {
                AKGallery* gallery = AKGallery.new;
                gallery.items=arr;
                gallery.modalPresentationStyle = 0;
                gallery.custUI=AKGalleryCustUI.new;
                gallery.selectIndex=initIndex;
                gallery.completion=^{
                    //NSLog(@"completion gallery");
                };
                //show gallery
                gallery.modalPresentationStyle =UIModalPresentationFullScreen;
                
                [[UIApplication sharedApplication].delegate.window.rootViewController presentAKGallery:gallery animated:YES completion:nil];
            }
            
            
        }
        
        
        
        
    }
    //
    else if ([@"previewImage" isEqualToString:call.method]){
        
        NSDictionary *dic = call.arguments;
        NSMutableArray *arr =[[NSMutableArray alloc]init];
        
        if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]] containsString:@"http"]) {
            AKGalleryItem* item = [AKGalleryItem itemWithTitle:@"图片详情" url:[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]] img:nil];
            [arr addObject:item];
            AKGallery* gallery = AKGallery.new;
            gallery.items=arr;
            gallery.custUI=AKGalleryCustUI.new;
            gallery.selectIndex=0;
            gallery.completion=^{
                //NSLog(@"completion gallery");
            };
            //show gallery
            gallery.modalPresentationStyle =UIModalPresentationFullScreen;
            
            [[UIApplication sharedApplication].delegate.window.rootViewController presentAKGallery:gallery animated:YES completion:nil];
            
            
            
        }else if ([[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]] containsString:@"var/"]||[[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]] containsString:@"CoreSimulator/"]){
            UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]]]];
            
            AKGalleryItem* item = [AKGalleryItem itemWithTitle:@"图片详情" url:nil img:image];
            [arr addObject:item];
            AKGallery* gallery = AKGallery.new;
            gallery.items=arr;
            gallery.modalPresentationStyle = 0;
            gallery.custUI=AKGalleryCustUI.new;
            gallery.selectIndex=0;
            gallery.completion=^{
                //NSLog(@"completion gallery");
            };
            //show gallery
            gallery.modalPresentationStyle =UIModalPresentationFullScreen;
            
            [[UIApplication sharedApplication].delegate.window.rootViewController presentAKGallery:gallery animated:YES completion:nil];
        }
        
    }else if ([@"previewVideo" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        PlayTheVideoVC *vc =[[PlayTheVideoVC alloc]init];
        vc.modalPresentationStyle=0;
        //vc.videoUrl =[NSString stringWithFormat:@"%@",@"http://apis.beboy.me/static/video/2019/07/20190730160222392332.mp4"];
        vc.videoUrl =[NSString stringWithFormat:@"%@",[dic objectForKey:@"path"]];
        vc.modalPresentationStyle =UIModalPresentationFullScreen;
        
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:vc animated:YES completion:^{
        }];
        
    }else if ([@"saveByteDataImageToGallery" isEqualToString:call.method]){
        NSDictionary *dic = call.arguments;
        FlutterStandardTypedData *data =[dic objectForKey:@"uint8List"];
        UIImage *image=[UIImage imageWithData:data.data];
        __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
         {
            NSString *str =assetURL.absoluteString;
            NSString *string =@"://";
            NSRange range = [str rangeOfString:string];//匹配得到的下标
            if(range.location+range.length<str.length){
                str = [str substringFromIndex:range.location+range.length];
                //NSLog(@"%@",str);
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
                    //NSLog(@"%@",str);
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

-(void)saveImageView:(NSInteger)index imagePHAsset:(NSArray*)assets arr:(NSMutableArray*)arr compressSize:(NSInteger)compressSize result:(FlutterResult)result{
    PHImageManager *manage =[[PHImageManager alloc]init];
    PHImageRequestOptions *option =[[PHImageRequestOptions alloc]init];
    
    
    if (index==assets.count) {
        
        NSMutableArray *urlArr =[[NSMutableArray alloc]init];
        
        for (int i=0; i<arr.count; i++) {
            
            if(([arr[i] containsString:@"GIF"]||[arr[i] containsString:@"gif"])&&isShowGif){
                NSDictionary *photoDic =@{
                    @"thumbPath":[NSString stringWithFormat:@"%@",arr[i]],
                    @"path":[NSString stringWithFormat:@"%@",arr[i]],
                };
                //取出路径
                [urlArr addObject:photoDic];
            }else{
                UIImage *imag =[UIImage imageWithContentsOfFile:arr[i]];
                NSData *data2=UIImageJPEGRepresentation(imag , 1.0);
                if (data2.length>compressSize) {
                    //压缩
                    data2=UIImageJPEGRepresentation(imag, (float)(compressSize/data2.length));
                }
                NSLog(@"_______%ld",data2.length);
                UIImage *image =[UIImage imageWithData:data2];
                //重命名并且保存
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString*urlString =arr[i];
                NSString *endString =[urlString lastPathComponent];
                
                if([endString containsString:@"gif"]||[endString containsString:@"GIF"]){
                    endString =@".png";
                }
                NSString *name = [NSString stringWithFormat:@"%@01%@",[formatter stringFromDate:[NSDate date]],endString];
                NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
                //保存到沙盒
                [UIImageJPEGRepresentation(image,1.0) writeToFile:jpgPath atomically:YES];
                NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),name];
                
                NSDictionary *photoDic =@{
                    @"thumbPath":[NSString stringWithFormat:@"%@",aPath3],
                    @"path":[NSString stringWithFormat:@"%@",aPath3],
                };
                //取出路径
                [urlArr addObject:photoDic];
            }
            
        }
        result(urlArr);
        return ;
        
    }
    PHAsset *asset  =assets[index];
    index++;
    [manage requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        UIImage *im =[UIImage imageWithData:imageData];
        //NSLog(@"info==%@",info);
        NSURL * path = [info objectForKey:@"PHImageFileURLKey"];
        NSString *str =path.absoluteString;
        NSString *imageLast = [str lastPathComponent];
        if (!path) {
            //                                    NSData * imageData = [info objectForKey:@"PHImageFileURLKey"];
            imageLast =[NSString stringWithFormat:@"%ld.%@",imageData.length,[dataUTI pathExtension]];
            ;
        }
        
        NSString *subString = [str substringFromIndex:7];
        if((![dataUTI containsString:@"gif"])&&(![dataUTI containsString:@"GIF"])){
            
            //若裁剪需要裁剪后的图片，需要保存一下
            //重命名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *name = [NSString stringWithFormat:@"%@%@",[formatter stringFromDate:[NSDate date]],imageLast];
            NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
            //保存到沙盒
            [UIImageJPEGRepresentation(im,1.0) writeToFile:jpgPath atomically:YES];
            NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),name];
            //取出路径
            [arr addObject:[NSString stringWithFormat:@"%@",aPath3]];
            
            [self saveImageView:index imagePHAsset:assets arr:arr  compressSize:compressSize result:result];
        }else{
            
            NSData *gifData = imageData;
            NSString *str =    [ImagePickersPlugin createFile:gifData suffix:@".gif"];
            [arr addObject:[NSString stringWithFormat:@"%@",str]];
            [self saveImageView:index imagePHAsset:assets arr:arr  compressSize:compressSize result:result];
            
        }
        
        if (arr.count==assets.count) {
            
        }
    }];
    
    
}





#pragma mark //保存gif
- (void)saveGifDataImage:(NSData*)data {
    
    //    [[NSURLSession sharedSession] downloadTaskWithResumeData:data completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:nil];
        
    }completionHandler:^(BOOL success,NSError*_Nullableerror) {
        
        if(success && !_Nullableerror) {
            
            NSLog(@"下载成功");
            
        }else{
            
            NSLog(@"下载失败");
            
        }
        
    }];
    //    }];
    
}
- (void)saveGifImage:(NSString*)urlString {
    
    NSURL *fileUrl = [NSURL URLWithString:urlString];
    
    [[[NSURLSession sharedSession] downloadTaskWithURL:fileUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", location);
        
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

#pragma //mark 通过视频的URL，获得视频缩略图
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
    
    //    NSString  *jpgPath = [NSHomeDirectory()     stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
    
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
