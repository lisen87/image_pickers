//
//  AKGalleryCustUI.m
//  AKGallery
//
//  Created by ak on 16/11/9.
//  Copyright © 2016年 ak. All rights reserved.
//

#import "AKGalleryCustUI.h"

@implementation AKGalleryCustUI
-(instancetype)init{
    self=[super init];
    //defaults value
    self.spaceBetweenViewer=1;
    self.viewerBarTint=[UIColor grayColor];
    self.viewerBackgroundBlack=NO;
    self.navigationTint=[UIColor grayColor];
    self.listTitle=@"图片列表";
    self.minZoomScale=0.5;
    self.maxZoomScale=3;
    self.onlyViewer=NO;
    return self;
}
@end
