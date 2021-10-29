//
//  TakePhotoViewController.h
//  image_pickers
//
//  Created by 崔小存 on 2021/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakePhotoViewController : UIViewController
@property(nonatomic,strong)NSDictionary *dic;
@property (nonatomic, copy) void (^doneEditBlock)(NSArray *);

@end

NS_ASSUME_NONNULL_END
