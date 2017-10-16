//
//  UIAlertView+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIAlertView+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSViewEvent.h"
#import <objc/message.h>
#import "DynamicStatistics.h"

void swizzling_alertView_clickedButtonAtIndex(id self, SEL _cmd, UIAlertView *alertView, NSInteger buttonIndex)
{
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id, NSInteger))objc_msgSend)(self, swizzledSEL, alertView, buttonIndex);

    DSViewEvent *event = [DSViewEvent eventWithView:alertView andIndex:buttonIndex];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
}

@implementation UIAlertView (DSAdditions)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setDelegate:) with:@selector(swizzling_setDelegate:)];
    });
}

-(void)swizzling_setDelegate:(id)delegate
{
    [[delegate class] swizzleInstanceSelector:@selector(alertView:clickedButtonAtIndex:) withIMP:(IMP)swizzling_alertView_clickedButtonAtIndex andTypeEncoding:"v@:@l"];
    [self swizzling_setDelegate:delegate];
}

@end
