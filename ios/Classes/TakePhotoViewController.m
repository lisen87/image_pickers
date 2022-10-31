//
//  TakePhotoViewController.m
//  image_pickers
//
//  Created by 崔小存 on 2021/10/27.
//

#import "TakePhotoViewController.h"
#import "AKGallery.h"
#import "PlayTheVideoVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import "ZLPhotoBrowser/ZLPhotoBrowser.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser-umbrella.h>

#import "BigImageViewController.h"
//#if __has_include(<ZLPhotoBrowser_objc/ZLPhotoBrowser.h>)
//#import <ZLPhotoBrowser_objc/ZLPhotoBrowser.h>
//#else
//#import "ZLPhotoBrowser.h"
//#endif

#define RUN_AFTER(s, b) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(s * NSEC_PER_SEC)), dispatch_get_main_queue(), b)

@interface TakePhotoViewController ()
{
    BOOL isDismiss;
    NSArray *arry;

}
@end

@implementation TakePhotoViewController

-(void)viewWillAppear:(BOOL)animated{
    if(isDismiss==YES){
        [self dismissViewControllerAnimated:NO completion:^(){
            if(arry.count>0){

            }else{
//                self.doneEditBlock(arry);
            }
        }];
    }else if(isDismiss ==NO){
        isDismiss=YES;
        arry =[[NSArray alloc]init];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isDismiss =NO;

    self.view.backgroundColor =[UIColor whiteColor];
//    UIButton*searchView  =[[UIButton alloc]initWithFrame:CGRectMake(0,0, 230, 100)];
//    [self.view addSubview: searchView];
//    searchView.layer.cornerRadius =8;
//    searchView.backgroundColor =[UIColor whiteColor];
//    [searchView addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];

    RUN_AFTER(1, ^(){
        [self push];
    });

}
-(void)push{
    NSDictionary *dic = self.dic;
    NSInteger selectCount =[[dic objectForKey:@"selectCount"] integerValue];//最多多少个
    NSInteger compressSize =[[dic objectForKey:@"compressSize"] integerValue]*1024;//大小

    NSString *galleryMode =[NSString stringWithFormat:@"%@",[dic objectForKey:@"galleryMode"]];//图片还是视频image video

    BOOL enableCrop =[[dic objectForKey:@"enableCrop"] boolValue];//是否裁剪
    if(selectCount>1){
        enableCrop =NO;
    }
    NSInteger height =[[dic objectForKey:@"height"] integerValue];//宽高比例

    NSInteger width =[[dic objectForKey:@"width"] integerValue];//宽高比例

    BOOL showCamera =[[dic objectForKey:@"showCamera"] boolValue];//显示摄像头

    NSString *cameraMimeType =[dic objectForKey:@"cameraMimeType"];//type   photo video 若不存在则为带相册的，若存在则直接打开相册相机

    ZLPhotoConfiguration *configuration =[ZLPhotoConfiguration default];
    configuration.maxSelectCount = selectCount;//最多选择多少张图
    configuration.allowMixSelect = NO;//不允许混合选择
    configuration.allowTakePhotoInLibrary =showCamera;//是否显示摄像头
    configuration.allowSelectOriginal =NO;//不选择原图
    configuration.allowEditImage =enableCrop;
    configuration.cellCornerRadio =5;
    configuration.editImageConfiguration.clipRatios=@[[[ZLImageClipRatio alloc]initWithTitle:@"" whRatio:((float)width/(float)height) isCircle:false]];

        ZLCustomCamera *camera = [[ZLCustomCamera alloc] init];

        if ([cameraMimeType isEqualToString:@"photo"]) {
            configuration.allowTakePhoto =YES;
            configuration.allowRecordVideo =NO;

        }else{
            configuration.allowTakePhoto = NO;
            configuration.allowRecordVideo = YES;
        }
//        camera.videoType = ZLExportVideoTypeMp4;
//       circleProgressColor = [UIColor redColor];
    configuration.maxRecordDuration = 15;

    camera.takeDoneBlock = ^(UIImage *image, NSURL *videoUrl) {
        
        NSLog(@"%@",videoUrl);

        NSLog(@"%@",image);

        if (image) {
            if(enableCrop){
                BigImageViewController *big =[[BigImageViewController alloc]init];
                big.configuration =configuration ;
                big.image =image;
                big.doneEditImageBlock = ^(UIImage * imageE) {
                    NSData *data2=UIImageJPEGRepresentation(imageE , 1.0);
                    float size =(float)compressSize/data2.length;
                    if(size>=1){
                        size =0.8;
                    }
                    data2=UIImageJPEGRepresentation(imageE, size);

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
                    arry =@[photoDic];
                    self.doneEditBlock(arry);
                    return ;

                };
                big.modalPresentationStyle =UIModalPresentationFullScreen;
                [self presentViewController:big animated:YES completion:nil];

//                    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:big animated:YES completion:^{
//                    }];
            }else{
                NSData *data2=UIImageJPEGRepresentation(image , 1.0);
                float size =(float)compressSize/data2.length;
                if(size>=1){
                    size =1;
                }
                data2=UIImageJPEGRepresentation(image, size);


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
                arry =@[photoDic];

                self. doneEditBlock(arry);
            
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
            UIImage *img = [self getImage:subString];
            NSData *data2=UIImageJPEGRepresentation(img , 1.0);
            NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.%@",NSHomeDirectory(),name,[self imageType:data2]];

            //保存到沙盒
            BOOL isSuccess=[UIImageJPEGRepresentation(img,1.0) writeToFile:aPath3 atomically:YES];
    


            NSDictionary *photoDic = @{
                @"thumbPath":[NSString stringWithFormat:@"%@",aPath3],
                @"path":[NSString stringWithFormat:@"%@",subString],
            };
            arry =@[photoDic];

            self.doneEditBlock(arry);
            return ;
            
        }
        
    };

//        camera.modalPresentationStyle =UIModalPresentationFullScreen;
    [self presentViewController:camera animated:YES completion:nil];
    
    
    

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
