//
//  AKGalleryViewer.m
//  AKGallery
//
//  Created by ak on 16/11/8.
//  Copyright © 2016年 ak. All rights reserved.
//

#import "AKGalleryViewer.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import <ImageIO/ImageIO.h>
#import <SDWebImage/UIImage+GIF.h>

@interface AKGalleryViewer()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate,UIActionSheetDelegate>
{
    bool isPinch;
    UIPanGestureRecognizer* userPan;
    UIPinchGestureRecognizer* userPinch;
}
@property(nonatomic,weak)AKGalleryViewerContainer* containerVC;
@end
@implementation AKGalleryViewer


-(instancetype)initWithContainer:(AKGalleryViewerContainer*)container index:(NSInteger)index{
    self = [super init];
    self.containerVC=container;
    self.index=index;
    return self;
}
//获取GIF图片每帧的时长
- (NSTimeInterval)gifImageDeleyTime:(CGImageSourceRef)imageSource index:(NSInteger)index {
    NSTimeInterval duration = 0;
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, NULL);
    if (imageProperties) {
        CFDictionaryRef gifProperties;
        BOOL result = CFDictionaryGetValueIfPresent(imageProperties, kCGImagePropertyGIFDictionary, (const void **)&gifProperties);
        if (result) {
            const void *durationValue;
            if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFUnclampedDelayTime, &durationValue)) {
                duration = [(__bridge NSNumber *)durationValue doubleValue];
                if (duration < 0) {
                    if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFDelayTime, &durationValue)) {
                        duration = [(__bridge NSNumber *)durationValue doubleValue];
                    }
                }
            }
        }
    }

    return duration;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self updateColor];
    if ([self.gallery itemForRow:self.index].img) {
        self.imgView.image= [self.gallery itemForRow:self.index].img;
    }
    
    if ([self.gallery itemForRow:self.index].url) {
//
        if ([[self.gallery itemForRow:self.index].url containsString:@"GIF"]||[[self.gallery itemForRow:self.index].url containsString:@"gif"]){
            NSData *data =[[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@",[self.gallery itemForRow:self.index].url]];
           [self.imgView setImage:[UIImage sd_imageWithGIFData:data]];
//              CGImageSourceRef gifSource;
//            gifSource =  CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
//            size_t frameCout=CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
//            NSMutableArray* frames=[[NSMutableArray alloc] init];//定义数组存储拆分出来的图片
//            double timeLong =0;
//            for (size_t i=0; i<frameCout;i++){
//
//                CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
//                UIImage* imageName=[UIImage imageWithCGImage:imageRef];//将图片源转换成UIimageView能使用的图片源
//                [frames addObject:imageName];//将图片加入数组中
//                CGImageRelease(imageRef);
//                timeLong =timeLong+[self gifImageDeleyTime:gifSource index:i];
//            }
//
//            self.imgView.animationImages=frames;//将图片数组加入UIImageView动画数组中
//            self.imgView.animationDuration=timeLong;//每次动画时长
//            [self.imgView startAnimating];//开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
        }else{
            [self.imgView sd_setImageWithURL:(NSURL*)[self.gallery itemForRow:self.index].url  placeholderImage:[UIImage imageNamed:@"error.png"] options:SDWebImageProgressiveLoad completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(error){
                    self.imgView.image=[UIImage imageNamed:@"error.png"];
                }
            }];
            
        }
        
        
        
        //self.imgView.image= [self.gallery itemForRow:self.index].img;
        
    }
    
    
    //    AKLog(@"viewer %p did appear %ld",self,self.index);
    
    
    if (self.gallery.choose) {
        self.gallery.choose(self.index);
    }
    
}


-(AKGallery*)gallery{
    
    return  (AKGallery*)self.containerVC.navigationController;
}

-(void)viewDidLoad{
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    sv.delegate=self;
    sv.userInteractionEnabled=YES;
    sv.contentSize=self.view.bounds.size;
    sv.minimumZoomScale=self.gallery.custUI.minZoomScale;
    sv.maximumZoomScale=self.gallery.custUI.maxZoomScale;
    [self.view addSubview:sv];
    self.scrollView=sv;
    
    //    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.view);
    //    }];
    
    //imageView
    UIImageView* imgv=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imgv.userInteractionEnabled=YES;
    imgv.contentMode=UIViewContentModeScaleAspectFit;
    [sv addSubview:imgv];
    self.imgView=imgv;
    
    //    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.view);
    //    }];
    
    
    //add gestures
    UITapGestureRecognizer * singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchBgColor)];
    singleTap.numberOfTapsRequired=1;
    [sv addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer * doubleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired=2;
    [sv addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
    
    //    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(userPan:)];
    //    [sv addGestureRecognizer:pan];
    //    pan.enabled=NO;
    //    userPan=pan;
    
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(userPinch:)];
    pinch.delegate=self;
    [sv addGestureRecognizer:pinch];
    userPinch=pinch;
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
                                                    
                                                    initWithTarget:self action:@selector(niehe:)];
    
    //        longPressReger.minimumPressDuration = 2.0;
    
    [sv addGestureRecognizer:longPressReger];
    
    
    
}



-(void)updateColor{
    //when viewdidload
    bool isBlack =  self.gallery.custUI.viewerBackgroundBlack;
    
    AKGalleryViewerContainer *containerVC= self.gallery.viewControllers[1];
    [containerVC.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    if (isBlack){
        self.gallery.navigationBarHidden=YES;
        containerVC.toolBar.hidden=YES;
        self.view.backgroundColor=[UIColor blackColor];
        containerVC.pageVC.view.backgroundColor=[UIColor blackColor];
    }else{
        self.gallery.navigationBarHidden=NO;
        containerVC.toolBar.hidden=NO;
        self.view.backgroundColor=[UIColor whiteColor];
        containerVC.pageVC.view.backgroundColor=[UIColor whiteColor];
    }
}
-(void)switchBgColor{
    
    UIColor* curColor=self.view.backgroundColor;
    AKGalleryViewerContainer *containerVC= self.navigationController.viewControllers[1];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (curColor==[UIColor whiteColor]) {
            self.navigationController.navigationBarHidden=YES;
            containerVC.toolBar.hidden=YES;
            self.view.backgroundColor=[UIColor blackColor];
            self.gallery.custUI.viewerBackgroundBlack=YES;
        }
        if (curColor==[UIColor blackColor]) {
            self.navigationController.navigationBarHidden=NO;
            containerVC.toolBar.hidden=NO;
            self.view.backgroundColor=[UIColor whiteColor];
            
            self.gallery.custUI.viewerBackgroundBlack=NO;
        }
    }];
}


#pragma mark - UIGesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)doubleTap:(UITapGestureRecognizer*)tap{
    
    
    CGPoint  point =  [tap locationInView:tap.view];
    
    //    AKLog(@"double tap %@",NSStringFromCGPoint(point));
    
    if(self.scrollView.zoomScale!=1){
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.scrollView setZoomScale:1];
            self.imgView.center=self.view.center;
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    
    [self.scrollView zoomToRect:CGRectMake(point.x-50, point.y-50, 100, 100) animated:YES];
    
    
    
    
    
}
- (void)niehe:(UILongPressGestureRecognizer*)longPressGesture{
    
}
-(void)collectionThePhoto{
    
    
}






-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        
        UIImageWriteToSavedPhotosAlbum(self.imgView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        
        
    }else if (buttonIndex == 1) {
    }else if(buttonIndex == 2) {
    }else if(buttonIndex == 3) {
    }
    
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    //NSLog(@"message is %@",message);
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}



-(void)userPinch:(UIPinchGestureRecognizer*)pinch{
    //    AKLog(@"userPinch scale:%f  velocity:%f",pinch.scale,pinch.velocity);
    float scale = pinch.scale;
    UIGestureRecognizerState state= pinch.state;
    
    
    switch (state) {
        case  UIGestureRecognizerStateBegan:
        {
            
            if(scale<1&&CGSizeEqualToSize( self.scrollView.contentSize, self.view.bounds.size) ){
                
                if (!self.interativeDismiss) {
                    self.interativeDismiss=AKInterativeDismissToList.new;
                }
                
                self.interativeDismiss.center=self.imgView.center;
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                
                //zoom on scrollview
                pinch.cancelsTouchesInView=YES;
            }
            userPan.enabled=YES;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            if (self.interativeDismiss) {
                //poping
                self.interativeDismiss.scale=scale;
                
                [self.interativeDismiss updateInteractiveTransition:scale];
                
            }
            
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            //            AKLog(@"end");
            //todo: shake navi title when end
            
            
            if (self.interativeDismiss) {
                
                //poping
                
                if (scale<0.6) {
                    [self.interativeDismiss finishInteractiveTransition];
                    
                }
                else{
                    [self.interativeDismiss cancelInteractiveTransition];
                }
                
                self.interativeDismiss=nil;
                
            }
            
            
            userPan.enabled=NO;
        }
            
            break;
        case UIGestureRecognizerStateCancelled:{
            //            AKLog(@"cancel");
            if (self.interativeDismiss) {
                //poping
                [self.interativeDismiss cancelInteractiveTransition];
                
                self.interativeDismiss=nil;
                
            }
            userPan.enabled=NO;
            
            //            AKLog(@"self.interativeDismiss=nil;");
        }break;
            
        default:
            break;
    }
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //    AKLog(@"zoom");
    
    if(scrollView.zoomScale<1){
        
        self.imgView.center=self.view.center;
    }
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView.subviews firstObject];
}


@end


@interface AKGalleryViewerContainer ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UINavigationControllerDelegate>
{
    NSArray*vcArr;
    UIBarButtonItem*previousBarBtn,*nextBarBtn;
    
}

@end

@implementation AKGalleryViewerContainer
-(instancetype)init{
    self = [super init];
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate=self;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.extendedLayoutIncludesOpaqueBars=YES;
    
    //back bar button
//    UIBarButtonItem* backBarBtn =[[UIBarButtonItem alloc]initWithImage:[self reSizeImage:[UIImage  imageNamed:@"icon_back"] toSize:CGSizeMake(45, 45)] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
       
    UIBarButtonItem* backBarBtn =[[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(pop) ];
    
    self.navigationItem.leftBarButtonItem=backBarBtn;
    
    //toolBar
    UIToolbar* tBar = UIToolbar.new;
    tBar.tintColor=self.gallery.custUI.viewerBarTint;
//    [self.view addSubview:tBar];
    self.toolBar=tBar;
    
    
    
//    [tBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@44);
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
    
    UIBarButtonItem*left =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    left.width=[UIScreen mainScreen].bounds.size.width/2-50;
    
    UIBarButtonItem*mid =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem* pBtn =[[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(previous)];
//
    UIBarButtonItem* nBtn =[[UIBarButtonItem alloc]initWithTitle:@">"  style:UIBarButtonItemStylePlain target:self action:@selector(next)];
//    self.toolBar.items=@[left,pBtn,mid,nBtn];
    mid.width=30;
    
    previousBarBtn = pBtn;
    nextBarBtn=nBtn;
    
    
    
    
    
    
    UIPageViewController* pvc= [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{
        UIPageViewControllerOptionInterPageSpacingKey:@(self.gallery.custUI.spaceBetweenViewer)
    } ];
    
    if (self.gallery.custUI.viewerBackgroundBlack) {
        pvc.view.backgroundColor=[UIColor blackColor];
    }else{
        pvc.view.backgroundColor=[UIColor whiteColor];
    }
    
    AKGalleryViewer* vcMid=[[AKGalleryViewer alloc]initWithContainer:self index:self.index];
    [pvc setViewControllers:@[vcMid] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pvc];
    
    pvc.delegate=self;
    pvc.dataSource=self;
    [self.view addSubview:pvc.view];
    self.pageVC=pvc;
    
    [self.view bringSubviewToFront:self.toolBar];
    [pvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.right.top.equalTo(self.view);
        //        make.bottom.equalTo(self.toolBar.mas_top);
        make.edges.equalTo(self.view);
    }];
    
    
    
    [self updateUI];
    
}


-(AKGallery*)gallery{
    
    return (AKGallery*)self.navigationController;
    
}


-(NSInteger)index{
    return self.gallery.selectIndex;
}


-(void)setIndex:(NSInteger)index{
    self.gallery.selectIndex=index;
}


-(void)pop{
    if (self.gallery.custUI.onlyViewer) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -  Toolbar Previous&Next
-(void)previous{
    
    AKGalleryViewer* curViewer=(AKGalleryViewer*)self.pageVC.viewControllers.firstObject;
    
    NSInteger idx= curViewer.index;
    
    if(idx<=0){
        return;
    }
    idx--;
    [self showViewerByIndex:idx direction:UIPageViewControllerNavigationDirectionReverse];
}




-(void)next{
    
    AKGalleryViewer* curViewer=(AKGalleryViewer*)self.pageVC.viewControllers.firstObject;
    
    NSInteger idx= curViewer.index;
    
    if (idx>=self.gallery.items.count-1) {
        
        return;
    }
    
    idx++;
    
    [self showViewerByIndex:idx direction:UIPageViewControllerNavigationDirectionForward];
}

-(void)showViewerByIndex:(NSInteger)idx direction:(UIPageViewControllerNavigationDirection)direction{
    
    
    AKGalleryViewer* vcMid=[[AKGalleryViewer alloc]initWithContainer:self index:idx];
    
    __weak typeof(self) ws=self;
    
    [self.pageVC setViewControllers:@[vcMid] direction:direction animated:YES completion:^(BOOL finished) {
        
        ws.index=idx;
        
        [ws updateUI];
    }];
    
}


-(void)updateUI{
    AKGalleryItem* item  = [self.gallery itemForRow:self.index];
    self.title=item.title;
    
    if (self.index==0) {
        previousBarBtn.enabled=NO;
    }else{
        previousBarBtn.enabled=YES;
    }
    
    if (self.index>=self.gallery.items.count-1) {
        nextBarBtn.enabled=NO;
    }else{
        nextBarBtn.enabled=YES;
    }
}


#pragma mark - UIPageViewController DataSource


- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger idx=self.index;
    
    if (idx>0) {
        idx--;
        
        AKGalleryViewer* viewer = [[AKGalleryViewer alloc]initWithContainer:self index:idx];
        
        //        AKLog(@"before %p idx:%ld",viewer,self.index);
        
        return viewer;
    }
    return nil;
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSInteger idx=self.index;
    
    if (idx<self.gallery.items.count-1) {
        
        idx++;
        
        AKGalleryViewer* viewer = [[AKGalleryViewer alloc]initWithContainer:self index:idx];
        //        AKLog(@"after %p idx:%ld selectedIdx:%ld",viewer,idx,self.index);
        return viewer;
    }
    return nil;
}

#pragma mark - UIPageViewController Delegate



- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0){
    //    AKLog(@"will Transition %p",pendingViewControllers.firstObject);
    //   AKGalleryViewer* viewer=(AKGalleryViewer*)pendingViewControllers[0];
    //    viewer.index=self.gallery.selectIndex;
}

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    AKGalleryViewer* viewer=(AKGalleryViewer*)pageViewController.viewControllers.firstObject;
    
    self.index=viewer.index;
    
    [self updateUI];
    //    AKLog(@"didFinishAnimating  finished:%@ viewer:%p  %ld previousViewControllers:%p  completed:%@",@(finished),viewer,self.index,previousViewControllers.firstObject,@(completed));
    
    //    AKLog(@"didFinishAnimating idx:%ld",viewer.index);
    
    if (completed) {
        //
    }
    
    
    
    
    
}

#pragma mark - UINavigationController Delegate

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0){
    
    //    AKLog(@"interaction %@",);
    //    return [AKInterativeDismissToList new];
    //    return  [AKInterativeDismissToList new];
    AKGalleryViewer* viewer= self.pageVC.viewControllers.firstObject;
    
    //    AKLog(@"inter :%@",viewer.interativeDismiss);
    return viewer.interativeDismiss;
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0){
    
    
    
    
    //viewer pop to container -> AKInterativeDismissList
    if([fromVC isKindOfClass:[AKGalleryViewerContainer class]]&&operation == UINavigationControllerOperationPop){
        
        //        AKGalleryViewerContainer* container = (AKGalleryViewerContainer*)fromVC;
        //        AKGalleryViewer* viewer= self.pageVC.viewControllers.firstObject;
        //        AKLog(@"animate %@", AKInterativeDismissToList.new);
        //        return viewer.interativeDismiss;
        return AKInterativeDismissToList.new;
    }
    return nil;
}
// 修改图片大小
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(5, 10,20, 20)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
