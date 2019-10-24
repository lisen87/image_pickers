//
//  AKInterativeDismissToList.h
//  AKGallery
//
//  Created by ak on 16/11/11.
//  Copyright © 2016年 ak. All rights reserved.
//
//
//              pop
//  viewer vc  -----> list vc



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AKInterativeDismissToList : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning>

@property(nonatomic,assign)float scale;

@property(nonatomic,assign)CGPoint center;

@end
