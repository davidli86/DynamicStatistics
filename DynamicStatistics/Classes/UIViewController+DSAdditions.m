//
//  UIViewController+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIViewController+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSViewEvent.h"
#import "DynamicStatistics+DSPrivate.h"

@implementation UIViewController (DSAdditions)

+(void)load{
    [DynamicStatistics registerClass:self];
}

+(void)loadSwizzle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self swizzleInstanceSelector:@selector(viewDidLoad) with:@selector(swizzling_viewDidLoad)];
        [self swizzleInstanceSelector:@selector(viewDidAppear:) with:@selector(swizzling_viewDidAppear:)];
//        [self swizzleInstanceSelector:@selector(viewDidDisappear:) with:@selector(swizzling_viewDidDisappear:)];
//        [self swizzleInstanceSelector:NSSelectorFromString(@"dealloc") with:@selector(swizzling_dealloc)];
    });
}

-(void)swizzling_viewDidLoad
{
    DSViewEvent *event = [DSViewEvent eventWithViewController:self andEventType:DSEventType_PageCreate];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    [self swizzling_viewDidLoad];
}

-(void)swizzling_viewDidAppear:(BOOL)animated
{
    DSViewEvent *event = [DSViewEvent eventWithViewController:self andEventType:DSEventType_PageAppear];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    [self swizzling_viewDidAppear:animated];
}

-(void)swizzling_viewDidDisappear:(BOOL)animated
{
    DSViewEvent *event = [DSViewEvent eventWithViewController:self andEventType:DSEventType_PageDisappear];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    [self swizzling_viewDidDisappear:animated];
}

-(void)swizzling_dealloc
{
    DSViewEvent *event = [DSViewEvent eventWithViewController:self andEventType:DSEventType_PageDestroy];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    [self swizzling_dealloc];
}

@end
