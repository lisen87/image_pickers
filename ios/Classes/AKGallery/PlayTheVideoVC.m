//
//  PlayTheVideoVC.m
//  Chat
//
//  Created by Admin on 2018/9/12.
//  Copyright © 2018年 桥通天下. All rights reserved.
//

#import "PlayTheVideoVC.h"
#import <AVFoundation/AVFoundation.h> //需要导入框架
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#define Frame_rectStatus ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define Frame_rectNav (self.navigationController.navigationBar.frame.size.height)
#define Frame_NavAndStatus (self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height)
#define CXCHeightX   ( ([UIScreen mainScreen].bounds.size.height>=812.00)?([[UIScreen mainScreen] bounds].size.height-34):([[UIScreen mainScreen] bounds].size.height)/1.000)
#define CXCWeight   ( ([[UIScreen mainScreen] bounds].size.width)/1.000)
#define IPHONE_X \ ({BOOL isPhoneX = NO;\ if (@available(iOS 11.0, *)) {\ isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\ }\ (isPhoneX);})

@interface PlayTheVideoVC ()

@end

@implementation PlayTheVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//    //替代导航栏的imageview
//    UIImageView *topImageView = [[UIImageView alloc]init];
//    if(![PlayTheVideoVC isPhoneX]){
//        topImageView.frame = CGRectMake(0, 0, CXCWeight, 64);
//    }else{
//        topImageView.frame = CGRectMake(0, 0, CXCWeight, 84);
//    }
//    topImageView.userInteractionEnabled = YES;
//    topImageView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:topImageView];

 

    if(_videoUrl){
        
        AVAsset *_asset;
        if([_videoUrl rangeOfString: @"http"].location == NSNotFound) {
            NSURL *url = [NSURL fileURLWithPath:_videoUrl];
            _asset = [AVURLAsset assetWithURL:url];
        } else {
            _asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_videoUrl]] options:nil];
        }
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:_asset];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.frame = CGRectMake(0, 0, CXCWeight, CXCHeightX);

        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.view.layer addSublayer:playerLayer];
        [player play];

    }else{
        
        
        
    }
  
    //添加返回按钮
    UIButton *  returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, Frame_rectStatus, Frame_rectNav, Frame_rectNav);
    if(![PlayTheVideoVC isPhoneX]){
        returnBtn.frame = CGRectMake(0, 20, 44, 44);
    }else{
        returnBtn.frame = CGRectMake(0, 40, 44, 44);
    }
    
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageNamed:@"IMG_4343.jpg"] forState:UIControlStateNormal];
    [returnBtn setTitle:@"<" forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
   
}
+ (BOOL)isPhoneX {
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
    
}
-(void)returnBtnAction{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
