//
//  UIScrollView+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIScrollView+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSViewEvent.h"
#import <objc/message.h>
#import "DynamicStatistics.h"

void swizzling_scrollViewDidScrollToTop(id self, SEL _cmd, UIScrollView *scrollView)
{
    DSViewEvent *event = [DSViewEvent eventWithView:scrollView andEventType:DSEventType_Scroll];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, scrollView);
}

void swizzling_scrollViewDidEndDecelerating(id self, SEL _cmd, UIScrollView *scrollView)
{
    DSViewEvent *event = [DSViewEvent eventWithView:scrollView andEventType:DSEventType_Scroll];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, scrollView);
}

void swizzling_scrollViewDidEndDragging_willDecelerate(id self, SEL _cmd, UIScrollView *scrollView, BOOL decelerate)
{
    DSViewEvent *event = [DSViewEvent eventWithView:scrollView andEventType:DSEventType_Scroll];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id, BOOL))objc_msgSend)(self, swizzledSEL, scrollView, decelerate);
}

void swizzling_scrollViewWillEndDragging_withVelocity_targetContentOffset(id self, SEL _cmd, UIScrollView *scrollView, CGPoint velocity, CGPoint *targetContentOffset)
{
    DSViewEvent *event = [DSViewEvent eventWithView:scrollView andEventType:DSEventType_Scroll];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id, CGPoint, CGPoint *))objc_msgSend)(self, swizzledSEL, scrollView, velocity, targetContentOffset);
}

@implementation UIScrollView (DSAdditions)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setDelegate:) with:@selector(swizzling_scrollView_setDelegate:)];
    });
}

-(void)swizzling_scrollView_setDelegate:(id<UIScrollViewDelegate>)delegate
{
    [[delegate class] swizzleInstanceSelector:@selector(scrollViewDidScrollToTop:) withIMP:(IMP)swizzling_scrollViewDidScrollToTop andTypeEncoding:"v@:@"];
    [[delegate class] swizzleInstanceSelector:@selector(scrollViewDidEndDecelerating:) withIMP:(IMP)swizzling_scrollViewDidEndDecelerating andTypeEncoding:"v@:@"];
    [[delegate class] swizzleInstanceSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withIMP:(IMP)swizzling_scrollViewDidEndDragging_willDecelerate andTypeEncoding:"v@:@B"];
    [[delegate class] swizzleInstanceSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:) withIMP:(IMP)swizzling_scrollViewWillEndDragging_withVelocity_targetContentOffset andTypeEncoding:"v@:@{CGPoint=ff}^{CGPoint=ff}"];
    
    [self swizzling_scrollView_setDelegate:delegate];
}

@end
