//
//  NSObject+DSForUnitTest.m
//  DynamicStatistics_Example
//
//  Created by David Li on 16/01/2018.
//  Copyright © 2018 492334421@qq.com. All rights reserved.
//

#import "NSObject+DSForUnitTest.h"
#import <DynamicStatistics_OC/NSObject+DSRuntimeAdditions.h>

NSString* sw_instance_debugDescription(id self, SEL _cmd)
{
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    if ([self respondsToSelector:swizzledSEL]) {
       return [self performSelector:swizzledSEL];
    }
    return nil;
}

NSString* sw_class_debugDescription(id self, SEL _cmd)
{
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    if ([self respondsToSelector:swizzledSEL]) {
        return [self performSelector:swizzledSEL];
    }
    return nil;
}

@implementation NSObject (DSForUnitTest)

- (NSString *)sw_description
{
    return [self sw_description];
}
- (NSString *)sw_debugDescription
{
    return [self sw_debugDescription];
}

+ (NSString *)sw_description
{
    return [self sw_description];
}

+ (NSString *)sw_debugDescription
{
    return [self sw_debugDescription];
}

@end
