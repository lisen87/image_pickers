//
//  BigImageViewController.h
//  AFNetworking
//
//  Created by 崔小存 on 2019/11/18.
//

#import <UIKit/UIKit.h>
//#import <Flutter/Flutter.h>
#import <ZLPhotoBrowser/ZLPhotoActionSheet.h>
#import <ZLPhotoBrowser/ZLImageEditTool.h>

NS_ASSUME_NONNULL_BEGIN

@interface BigImageViewController : UIViewController
@property(nonatomic,strong)  ZLPhotoConfiguration *configuration;
@property(nonatomic,strong)  UIImage *image;
@property (nonatomic, copy) void (^doneEditImageBlock)(UIImage *);

@end

NS_ASSUME_NONNULL_END
