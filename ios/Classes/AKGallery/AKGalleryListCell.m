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
        
        if ([model.url containsString:@"GIF"]) {
            NSURL *fileUrl = [NSURL URLWithString:model.url];//加载GIF图片
            
            CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);//将GIF图片转换成对应的图片源
            
            size_t frameCout=CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
            
            NSMutableArray* frames=[[NSMutableArray alloc] init];//定义数组存储拆分出来的图片
            
            
            
            for (size_t i=0; i<frameCout;i++){
                
                 CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
                
                UIImage* imageName=[UIImage imageWithCGImage:imageRef];//将图片源转换成UIimageView能使用的图片源
                
                [frames addObject:imageName];//将图片加入数组中
                
                CGImageRelease(imageRef);
                
                }
            
            CFRelease(gifSource);
            
            
            imgV.animationImages=frames;//将图片数组加入UIImageView动画数组中
            
            imgV.animationDuration=3;//每次动画时长
            
            [imgV startAnimating];//开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
            
        }else{
            
            [imgV sd_setImageWithURL:(NSURL*)model.url  placeholderImage:[UIImage imageNamed:@"error.png"] options:SDWebImageProgressiveLoad completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if(error){
                    imgV.image=[UIImage imageNamed:@"error.png"];
                }
            }];
        }
        
        //        [imgV sd_setImageWithURL:(NSURL*)model.url  placeholderImage:[UIImage imageNamed:@"error.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //            if(error){
        //                imgV.image=[UIImage imageNamed:@"error.png"];
        //            }
        //        }];
    }
}
@end
