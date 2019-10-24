//
//  AKGalleryCustUI.h
//  AKGallery
//
//  Created by ak on 16/11/9.
//  Copyright © 2016年 ak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKGalleryCustUI : NSObject

#pragma mark - Navigation
//navigation tint
//effects on AKGallery . default red
//修改导航色调， 可修改返回图标颜色
@property(nonatomic,strong)UIColor* navigationTint;

#pragma mark - List
//default @"概览"
//图片列表标题
@property(nonatomic,strong)NSString* listTitle;

#pragma mark - Viewer
//default  1
//图片间距
@property(nonatomic,assign)float spaceBetweenViewer;

//image viewer bar tintcolor
//底部工具栏，可修改工具栏图标颜色
@property(nonatomic,strong)UIColor* viewerBarTint;

//default no
//是否黑色背景
@property(nonatomic,assign)bool viewerBackgroundBlack;

//default 0.5
//最大缩小倍数
@property(nonatomic,assign)float minZoomScale;

//default 3
//最大放大倍数
@property(nonatomic,assign)float maxZoomScale;

//default NO
//if yes ,it will pop to list
//是否只是单张浏览
@property(nonatomic,assign)bool onlyViewer;

@end
