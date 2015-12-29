//
//  main.m
//  MyDiary
//
//  Created by zhouhao on 15-3-6.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appKey=@"3a0a9b0967aee9e843a87b8a43772f26";
        [Bmob registerWithAppKey:appKey];
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
