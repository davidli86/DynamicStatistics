//
//  UIApplication+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIApplication+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "UIView+DSAdditions.h"
#import "DSViewEvent.h"
#import "DynamicStatistics.h"

@implementation UIApplication (DSAdditions)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(sendAction:to:from:forEvent:) with:@selector(swizzling_sendAction:to:from:forEvent:)];
    });
}

-(BOOL)swizzling_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event
{
    if ([sender isKindOfClass:[UIView class]]) {
        DSViewEvent *event = [DSViewEvent eventWithView:sender];
        [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    }else{
        DSViewEvent *event = [DSViewEvent eventWithNonView:sender andIndex:0];
        [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    }
    
    return [self swizzling_sendAction:action to:target from:sender forEvent:event];
}



@end
