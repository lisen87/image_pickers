//
//  ChooseImageManager.m
//  image_pickers
//
//  Created by 崔小存 on 2023/4/7.
//

#import "ChooseImageManager.h"

@implementation ChooseImageManager
+ (instancetype)shareInstance
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];

    });
    return sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageDic = [NSMutableDictionary dictionary];
    }
    return self;
}


@end
