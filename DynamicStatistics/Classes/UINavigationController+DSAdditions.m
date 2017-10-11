//
//  UINavigationController+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UINavigationController+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"

@implementation UINavigationController (DSAdditions)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(navigationBar:shouldPopItem:) with:@selector(swizzling_navigationBar:shouldPopItem:)];
    });
}

- (BOOL)swizzling_navigationBar:(UINavigationBar *)navigationBar
        shouldPopItem:(UINavigationItem *)item
{
    BOOL result = [self swizzling_navigationBar:navigationBar shouldPopItem:item];
    NSLog(@"swizzling_navigationBar_shouldPopItem: %@ result: %d", item.title, result);
    return result;
}

@end
