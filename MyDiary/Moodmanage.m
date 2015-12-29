//
//  Moodmanage.m
//  MyDiary
//
//  Created by zhouhao on 15/5/18.
//  Copyright (c) 2015年 zhengmeng. All rights reserved.
//

#import "Moodmanage.h"
static Moodmanage *singleton=nil;

@implementation Moodmanage

-(id)init{
    self=[super init];
    if (self!=nil) {
        NSString* colorPath=[[NSBundle mainBundle]pathForResource:@"moodcolor" ofType:@"plist"];
        _colorConfig=[NSDictionary dictionaryWithContentsOfFile:colorPath];
    
    }
    return self;
}

- (UIColor *)getColorWithName:(NSString *)name
{
    if (name.length == 0){
        return nil;
    }
    
    NSString *rgb = [self.colorConfig objectForKey:name];
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    
    if (rgbs.count == 3){
        float r = [rgbs[0] floatValue];
        float g = [rgbs[1] floatValue];
        float b = [rgbs[2] floatValue];
        UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
        return color;
    }
    
    return nil;
}

+(Moodmanage*)shareInstance{
    if (singleton == nil){
        @synchronized(self)
        {
            singleton = [[Moodmanage alloc] init];
        }
    }
    
    return singleton;

}

@end
