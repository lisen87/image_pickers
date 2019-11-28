//
//  AKInterativeDismissToList.m
//  AKGallery
//
//  Created by ak on 16/11/11.
//  Copyright © 2016年 ak. All rights reserved.
//

#import "AKInterativeDismissToList.h"
#import "AKGalleryViewer.h"
#import "AKGalleryList.h"
#import <AVFoundation/AVFoundation.h>

@interface AKInterativeDismissToList()
@property(nonatomic,strong)id <UIViewControllerContextTransitioning> ctx;
@property(nonatomic,strong)UIView* fromView;
@property(nonatomic,strong)AKGalleryViewer* fromVC;
@property(nonatomic,strong)UIView* toView;

@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* imgView;
@property(nonatomic,assign)CGRect finalVCFrame;
@property(nonatomic,assign)CGRect initImageFrame;
@property(nonatomic,assign)CGRect finalImageFrame;

@property(nonatomic,assign)CGSize initContentSize;

@end
@implementation AKInterativeDismissToList

#pragma mark - UIViewControllerAnimatedTransitioning


// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.35f;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    
    //   UITransitionContextToViewControllerKey
    //   UITransitionContextFromViewControllerKey
    
    //AKGalleryList
    UIViewController* toVC= [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //AKGalleryViewer
    UIViewController* fromVC= [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    UIView* container= transitionContext.containerView;
    [container addSubview:toVC.view];
    
    UIView* bgView= [[UIView alloc]initWithFrame:toVC.view.bounds];
    bgView.backgroundColor=[UIColor whiteColor];
    [container addSubview:bgView];
    bgView.alpha=1;
    self.bgView=bgView;
    
    
    
    //图片序号
    NSInteger imgDataIdx=0;
    
    if ([fromVC isKindOfClass:[AKGalleryViewerContainer class]]) {
        //add imageview
        AKGalleryViewerContainer* containerVC = (AKGalleryViewerContainer*)fromVC;
        AKGalleryViewer* viewerVC=  containerVC.pageVC.viewControllers.firstObject;
        imgDataIdx=viewerVC.index;
        UIImage*img=viewerVC.imgView.image;
        if (viewerVC.imgView.image) {
            UIImageView* imgV= [[UIImageView alloc]init];
                   //从imageView把image的大小计算出来
                   CGRect imgFrame= AVMakeRectWithAspectRatioInsideRect(img.size, viewerVC.imgView.bounds);
                   
                   
                   imgV.frame=imgFrame;
                   imgV.image=img;
                   imgV.contentMode=UIViewContentModeScaleAspectFill;
                   [container addSubview:imgV];
                   self.imgView=imgV;
        }else{
            self.imgView =viewerVC.imgView;
        }
       
    }
    
    
    CGRect finalImageFrame=CGRectZero;
    if([toVC isKindOfClass:[AKGalleryList class]]){
        AKGalleryList* listVC=(AKGalleryList*)toVC;
        
        NSIndexPath* idx=[NSIndexPath indexPathForRow:imgDataIdx inSection:0];
        
        //get cell frame
        CGRect cellF=[listVC.collectionView layoutAttributesForItemAtIndexPath:idx].frame;
        
        //移动cell到屏幕中
        [listVC.collectionView scrollToItemAtIndexPath:idx atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        
        
        [listVC.collectionView scrollRectToVisible:cellF animated:NO];
        
        //计算cell在window的位置
        //当先展示viewer 在pop到list时，cell=nil
        UICollectionViewCell* cell= [listVC.collectionView cellForItemAtIndexPath:idx];
        if(cell){
            finalImageFrame= [cell convertRect:cell.bounds  toView:nil];
        }
        else{
            finalImageFrame= [listVC.collectionView convertRect:cellF  toView:nil];
        }
        
        
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.imgView.frame=finalImageFrame;
        self.bgView.alpha=0;
        
    } completion:^(BOOL finished) {
        [self.imgView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
    
    
}


-(UIImage*)capture:(UIView*)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx=  UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* img= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


//UIPercentDrivenInteractiveTransition

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    
    //不能调用super方法 否则bug:nav导航闪烁
    //    [super startInteractiveTransition:transitionContext];
    
    self.ctx=transitionContext;
    
    //AKGalleryList
    UIViewController* toVC= [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //AKGalleryContainer
    UIViewController* fromVC= [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    toVC.view.frame= [transitionContext finalFrameForViewController:toVC];
    self.finalVCFrame=[transitionContext finalFrameForViewController:toVC];
    self.toView=toVC.view;
    self.fromView=fromVC.view;
    
    UIView* container= [self.ctx containerView];
    [container addSubview:self.toView];
    //NSLog(@"startInteractiveTransition %ld",container.subviews.count);
    
    UIView* bgView= [[UIView alloc]initWithFrame:self.finalVCFrame];
    bgView.backgroundColor=[UIColor whiteColor];
    [container addSubview:bgView];
    bgView.alpha=1;
    self.bgView=bgView;
    
    
    //图片序号
    NSInteger imgDataIdx=0;
    
    if ([fromVC isKindOfClass:[AKGalleryViewerContainer class]]) {
        //add imageview
        AKGalleryViewerContainer* containerVC = (AKGalleryViewerContainer*)fromVC;
        AKGalleryViewer* viewerVC=  containerVC.pageVC.viewControllers.firstObject;
        imgDataIdx=viewerVC.index;
        UIImage*img=viewerVC.imgView.image;
        UIImageView* imgV= [[UIImageView alloc]init];
        //从imageView把image的大小计算出来
        CGRect imgFrame= AVMakeRectWithAspectRatioInsideRect(img.size, viewerVC.imgView.bounds);
        imgV.frame=imgFrame;
        imgV.image=img;
        imgV.contentMode=UIViewContentModeScaleAspectFill;
        [container addSubview:imgV];
        self.imgView=imgV;
        
        self.initImageFrame= imgFrame;
        
        self.fromVC=viewerVC;;
        
        
        self.initContentSize=self.fromVC.scrollView.contentSize;
    }
    
    
    CGRect finalImageFrame=CGRectZero;
    if([toVC isKindOfClass:[AKGalleryList class]]){
        AKGalleryList* listVC=(AKGalleryList*)toVC;
        
        NSIndexPath* idx=[NSIndexPath indexPathForRow:imgDataIdx inSection:0];
        
        //get cell frame
        CGRect cellF=[listVC.collectionView layoutAttributesForItemAtIndexPath:idx].frame;
        
        //移动cell到屏幕中
        [listVC.collectionView scrollToItemAtIndexPath:idx atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        
        
        [listVC.collectionView scrollRectToVisible:cellF animated:NO];
        
        //计算cell在window的位置
        UICollectionViewCell* cell= [listVC.collectionView cellForItemAtIndexPath:idx];
        
        finalImageFrame= [cell convertRect:cell.bounds  toView:nil];
        
        self.finalImageFrame=finalImageFrame;
    }
    
    
   

}


- (void)updateInteractiveTransition:(CGFloat)percentComplete{
    
    
        [super updateInteractiveTransition:1-percentComplete];
        
        //NSLog(@"updateInteractiveTransition %f",1-percentComplete);
        
        self.bgView.alpha=percentComplete;
        
        self.imgView.transform=CGAffineTransformMakeScale(self.scale, self.scale);
        
        self.imgView.center=self.center;
    
    
    
}


- (void)cancelInteractiveTransition{
    //NSLog(@"cancelInteractiveTransition %f",self.percentComplete);
    [super cancelInteractiveTransition];
    
    if(self.percentComplete==0){
        //放大图片 不恢复图片大小
        [self.imgView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [self.ctx completeTransition:NO];
    }
    else{
        //恢复图片大小
        [UIView animateWithDuration:0.2 animations:^{
            self.imgView.transform=CGAffineTransformMakeScale(1, 1);
            self.imgView.frame=self.initImageFrame;
            self.bgView.alpha=1;
            
        } completion:^(BOOL finished) {
            [self.imgView removeFromSuperview];
            [self.bgView removeFromSuperview];
            [self.ctx completeTransition:NO];
        }];
    }
    
    
    
    
    
    
}
- (void)finishInteractiveTransition{
    [super finishInteractiveTransition];
    
    //NSLog(@"finishInteractiveTransition");
    
    
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.imgView.frame=self.finalImageFrame;
        self.bgView.alpha=0;
    } completion:^(BOOL finished) {
     
        [UIView animateWithDuration:0.1 animations:^{
            self.imgView.alpha=0;
            
        } completion:^(BOOL finished) {
            [self.imgView removeFromSuperview];
            [self.bgView removeFromSuperview];
            [self.ctx completeTransition:YES];
        }];
        
    }];
    
}




@end
