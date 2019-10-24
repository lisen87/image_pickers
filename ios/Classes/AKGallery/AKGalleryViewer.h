//
//  AKGalleryViewer.h
//  AKGallery
//
//  Created by ak on 16/11/8.
//  Copyright © 2016年 ak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKInterativeDismissToList.h"
#import "AKGallery.h"

@class AKGalleryViewerContainer;
typedef NS_ENUM(NSInteger,AKGalleryViewerContainerStyle) {
    AKGalleryViewerContainerStyleWhite,
    AKGalleryViewerContainerStyleBlack
    
};
@interface AKGalleryViewer : UIViewController

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)AKInterativeDismissToList* interativeDismiss;


-(instancetype)initWithContainer:(AKGalleryViewerContainer*)container index:(NSInteger)index;

//use for AKInterativeDismissToList.m
@property(nonatomic,strong)UIImageView *imgView;

@property(nonatomic,strong)UIScrollView *scrollView;
@end


@interface AKGalleryViewerContainer : UIViewController


@property(nonatomic,assign)NSInteger index;

//use for AKInterativeDismissToList.m
@property(nonatomic,strong)UIPageViewController *pageVC;


@property(nonatomic,strong)UIToolbar* toolBar;

@end
