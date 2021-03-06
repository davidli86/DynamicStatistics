//
//  UINavigationController+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UINavigationController+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSViewEvent.h"
#import "DynamicStatistics+DSPrivate.h"

@implementation UINavigationController (DSAdditions)

+(void)load{
    [DynamicStatistics registerClass:self];
}

+(void)loadSwizzle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(navigationBar:shouldPopItem:) with:@selector(swizzling_navigationBar:shouldPopItem:)];
    });
}

- (BOOL)swizzling_navigationBar:(UINavigationBar *)navigationBar
        shouldPopItem:(UINavigationItem *)item
{
    DSViewEvent *event = [DSViewEvent eventWithNonView:item andIndex:0 eventType:DSEventType_PagePopOut];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    BOOL result = [self swizzling_navigationBar:navigationBar shouldPopItem:item];
    return result;
}

@end
