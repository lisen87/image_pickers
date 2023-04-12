//
//  ChooseImageManager.h
//  image_pickers
//
//  Created by 崔小存 on 2023/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseImageManager : NSObject
+ (instancetype)shareInstance;
@property (strong, nonatomic)NSMutableDictionary * imageDic;

@end

NS_ASSUME_NONNULL_END
