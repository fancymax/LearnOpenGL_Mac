//
//  FLglmWrapper.m
//  Lesson5
//
//  Created by fancymax on 1/13/2017.
//  Copyright © 2017年 fancy. All rights

#import <Foundation/Foundation.h>

@interface FLglmWrapper:NSObject

+(float*) lookAt:(float*)position target:(float*)target upVector:(float*)up;
+(void) freeMatrix:(float*)matrix;
    



@end
