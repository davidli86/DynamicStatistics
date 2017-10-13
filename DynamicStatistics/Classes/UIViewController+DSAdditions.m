//
//  UIViewController+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIViewController+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSEvent.h"

@implementation UIViewController (DSAdditions)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(viewDidLoad) with:@selector(swizzling_viewDidLoad)];
        [self swizzleInstanceSelector:@selector(viewDidAppear:) with:@selector(swizzling_viewDidAppear:)];
        [self swizzleInstanceSelector:@selector(viewDidDisappear:) with:@selector(swizzling_viewDidDisappear:)];
        [self swizzleInstanceSelector:NSSelectorFromString(@"dealloc") with:@selector(swizzling_dealloc)];
    });
}

-(void)swizzling_viewDidLoad
{
    [self swizzling_viewDidLoad];
    
    DSEvent *event = [DSEvent eventWithViewController:self andEventType:DSEventType_PageCreate];
    NSLog(@"\nEvent Type: %@\nView Path: %@", event.eventTypeDescription, event.viewPath);
}

-(void)swizzling_viewDidAppear:(BOOL)animated
{
    [self swizzling_viewDidAppear:animated];
    
    DSEvent *event = [DSEvent eventWithViewController:self andEventType:DSEventType_PageAppear];
    NSLog(@"\nEvent Type: %@\nView Path: %@", event.eventTypeDescription, event.viewPath);
}

-(void)swizzling_viewDidDisappear:(BOOL)animated
{
    [self swizzling_viewDidDisappear:animated];
    
    DSEvent *event = [DSEvent eventWithViewController:self andEventType:DSEventType_PageDisappear];
    NSLog(@"\nEvent Type: %@\nView Path: %@", event.eventTypeDescription, event.viewPath);
}

-(void)swizzling_dealloc
{
    DSEvent *event = [DSEvent eventWithViewController:self andEventType:DSEventType_PageDestroy];
    NSLog(@"\nEvent Type: %@\nView Path: %@", event.eventTypeDescription, event.viewPath);
    
    [self swizzling_dealloc];
}

@end
