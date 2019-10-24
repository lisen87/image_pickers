//
//  AppDelegate.m
//  Runner
//
//  Created by 崔小存 on 2019/10/24.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];

}
@end
