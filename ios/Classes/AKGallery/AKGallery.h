//
//  AKGallery.h
//  AKGallery
//
//  Created by ak on 16/11/8.
//  Copyright © 2016年 ak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKGalleryCustUI.h"


#ifdef DEBUG


#define AKLog(fmt, ...) \
//NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);//注释则不打印日志

#else
#define Debug(...)
#endif

@interface AKGalleryItem : NSObject

@property(nonatomic,copy)NSString* title,*url;

@property(nonatomic,copy)UIImage* img;
@property(nonatomic,copy)NSString* imgUrl;
@property(nonatomic,copy)NSString* memonId;


+(instancetype)itemWithTitle:(NSString*)title url:(NSString* )url img:(UIImage*)img;


@end


@protocol AKGalleryDelegate <NSObject>

//-(void)AKGalleryItemForIdx;

@end
@interface AKGallery : UINavigationController

//customer params on UI
//指定UI参数
@property(nonatomic,strong)AKGalleryCustUI* custUI;
@property(nonatomic,strong)NSString*memoId;
@property(nonatomic,strong)NSArray* items;
@property(nonatomic,strong)NSArray* imgUrlArr;


//default 0
@property(nonatomic,assign)NSInteger selectIndex;

@property(nonatomic,copy)void(^choose)(NSInteger index);

@property(nonatomic,copy)void(^completion)();

-(AKGalleryItem*)itemForRow:(NSInteger)row;

-(AKGalleryItem*)selectedItem;

@end


@interface UIViewController(AKGallery)

-(void)presentAKGallery:(AKGallery *)gallery animated:(BOOL)flag completion:(void (^)(void))completion;
@end
