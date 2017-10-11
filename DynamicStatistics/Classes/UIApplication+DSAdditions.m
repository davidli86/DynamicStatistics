//
//  UIApplication+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIApplication+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"

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
    NSLog(@"swizzling_sendAction: %@ to: %@ from: %@ forEvent: %d", NSStringFromSelector(action), [target class], [sender class], event.type);
    return [self swizzling_sendAction:action to:target from:sender forEvent:event];
}

@end
