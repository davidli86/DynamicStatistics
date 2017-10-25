//
//  UIGestureRecognizer+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIGestureRecognizer+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSViewEvent.h"
#import <objc/message.h>
#import "DynamicStatistics+DSPrivate.h"

void swizzling_targetAction(id self, SEL _cmd, UIGestureRecognizer *sender){
    if (sender.state == UIGestureRecognizerStateEnded) {
        //UIPanGestureRecognizer事件触发频率太高，暂不考虑。UIScrollView的滑动事件通过hook delegate来抓取
        DSEventType eventType = DSEventType_Unknown;
        if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
            eventType = DSEventType_GestureTap;
        }else if ([sender isKindOfClass:[UIPinchGestureRecognizer class]]){
            eventType = DSEventType_GesturePinch;
        }else if ([sender isKindOfClass:[UIRotationGestureRecognizer class]]){
            eventType = DSEventType_GestureRotation;
        }else if([sender isKindOfClass:[UISwipeGestureRecognizer class]]){
            eventType = DSEventType_GestureSwipe;
        }else if ([sender isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]){
            eventType = DSEventType_GestureScreenEdgePan;
        }else if ([sender isKindOfClass:[UILongPressGestureRecognizer class]]){
            eventType = DSEventType_GestureLongPress;
        }
        if (eventType != DSEventType_Unknown) {
            DSViewEvent *event = [DSViewEvent eventWithView:sender.view andEventType:eventType];
            [[DynamicStatistics sharedInstance] tryToLogEvent:event];
        }
    }
    
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    if ([self respondsToSelector:swizzledSEL]) {
        ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, sender);
    }
}

@implementation UIGestureRecognizer (DSAdditions)

+(void)load{
    [DynamicStatistics registerClass:self];
}

+(void)loadSwizzle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(initWithTarget:action:) with:@selector(swizzling_initWithTarget:action:)];
        [self swizzleInstanceSelector:@selector(addTarget:action:) with:@selector(swizzling_addTarget:action:)];
    });
}

-(instancetype)swizzling_initWithTarget:(id)target action:(SEL)action
{
    [[target class] swizzleInstanceSelector:action withIMP:(IMP)swizzling_targetAction andTypeEncoding:"v@:@"];
    return [self swizzling_initWithTarget:target action:action];
}

-(void)swizzling_addTarget:(id)target action:(SEL)action
{
    [[target class] swizzleInstanceSelector:action withIMP:(IMP)swizzling_targetAction andTypeEncoding:"v@:@"];
    [self swizzling_addTarget:target action:action];
}

@end
