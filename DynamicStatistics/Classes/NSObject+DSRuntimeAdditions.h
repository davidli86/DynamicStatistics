//
//  NSObject+DSRuntimeAdditions.h
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import <Foundation/Foundation.h>

#define SwizzlingMethodPrefix @"swizzling_"

@interface NSObject (DSRuntimeAdditions)

+ (void)swizzleInstanceSelector:(SEL)originalSelector with:(SEL)swizzledSelector;
+ (void)swizzleClassSelector:(SEL)originalSelector with:(SEL)swizzledSelector;

+ (void)swizzleInstanceSelector:(SEL)originalSelector withIMP:(IMP)swizzledImplementation andTypeEncoding:(const char *)types;
+ (void)swizzleClassSelector:(SEL)originalSelector withIMP:(IMP)swizzledImplementation andTypeEncoding:(const char *)types;

@end
