//
//  FLglmWrapper.m
//  Lesson5
//
//  Created by fancymax on 1/13/2017.
//  Copyright © 2017年 fancy. All rights

#import <Foundation/Foundation.h>

@interface FLglmWrapper:NSObject

+(float*) lookAtPosition:(float*)position target:(float*)target upVector:(float*)up;
+(float*) perspectiveAtFov:(float)FOV aspect:(float)aspect near:(float)near far:(float)far;
+(void) freeMatrix:(float*)matrix;

+(float*) translateAtX:(float)x Y:(float)y Z:(float)z;
+(float*) translateFrom:(float*)arrayMatrix X:(float)x Y:(float)y Z:(float)z;
+(float*) rotateFrom:(float*)arrayMatrix angle:(float)angle X:(float)x Y:(float)y Z:(float)z;
    



@end
