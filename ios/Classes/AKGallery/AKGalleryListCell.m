//
//  AKGalleryListCell.m
//  AKGallery
//
//  Created by ak on 16/11/8.
//  Copyright © 2016年 ak. All rights reserved.
//

#import "AKGalleryListCell.h"
#import "UIImageView+WebCache.h"

@interface AKGalleryListCell()
{
    UIImageView* imgV;
}
@end
@implementation AKGalleryListCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    imgV = [UIImageView new];
    [self addSubview:imgV];
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    imgV.frame=self.bounds;
    
}


-(void)setModel:(AKGalleryItem *)model{
    _model=model;
    
    
    
    if (model.img) {
        imgV.image=model.img;
    }
    if(model.url){
        [imgV sd_setImageWithURL:(NSURL*)model.url  placeholderImage:[UIImage imageNamed:@"error.png"] options:SDWebImageProgressiveLoad completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(error){
                imgV.image=[UIImage imageNamed:@"error.png"];
            }
        }];
//        [imgV sd_setImageWithURL:(NSURL*)model.url  placeholderImage:[UIImage imageNamed:@"error.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if(error){
//                imgV.image=[UIImage imageNamed:@"error.png"];
//            }
//        }];
    }
}
@end
