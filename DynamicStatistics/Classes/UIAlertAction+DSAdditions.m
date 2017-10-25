//
//  UIAlertAction+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIAlertAction+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSViewEvent.h"
#import "DynamicStatistics+DSPrivate.h"

@implementation UIAlertAction (DSAdditions)

+(void)load{
    [DynamicStatistics registerClass:self];
}

+(void)loadSwizzle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleClassSelector:@selector(actionWithTitle:style:handler:) with:@selector(swizzling_actionWithTitle:style:handler:)];
    });
}

+ (instancetype)swizzling_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler;
{
    return [self swizzling_actionWithTitle:title style:style handler:^(UIAlertAction *action) {
        DSViewEvent *event = [DSViewEvent eventWithNonView:action andIndex:0];
        [[DynamicStatistics sharedInstance] tryToLogEvent:event];
        
        handler(action);
    }];
}

@end
