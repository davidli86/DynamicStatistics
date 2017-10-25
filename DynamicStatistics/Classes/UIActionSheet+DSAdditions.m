//
//  UIActionSheet+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIActionSheet+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSViewEvent.h"
#import "DynamicStatistics.h"
#import <objc/message.h>

void swizzling_actionSheet_clickedButtonAtIndex(id self, SEL _cmd, UIActionSheet *actionSheet, NSInteger buttonIndex)
{
    DSViewEvent *event = [DSViewEvent eventWithView:actionSheet andIndex:buttonIndex];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    if ([self respondsToSelector:swizzledSEL]) {
        ((void(*)(id, SEL, id, NSInteger))objc_msgSend)(self, swizzledSEL, actionSheet, buttonIndex);
    }
}

@implementation UIActionSheet (DSAdditions)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setDelegate:) with:@selector(swizzling_setDelegate:)];
    });
}

-(void)swizzling_setDelegate:(id<UIActionSheetDelegate>)delegate
{
    [[delegate class] swizzleInstanceSelector:@selector(actionSheet:clickedButtonAtIndex:) withIMP:(IMP)swizzling_actionSheet_clickedButtonAtIndex andTypeEncoding:"v@:@l"];
    [self swizzling_setDelegate:delegate];
}

@end
