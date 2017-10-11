//
//  UIViewController+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIViewController+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"

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
    NSLog(@"swizzling_viewDidLoad: %@", [self class]);
    [self swizzling_viewDidLoad];
}

-(void)swizzling_viewDidAppear:(BOOL)animated
{
    NSLog(@"swizzling_viewDidAppear: %@", [self class]);
    [self swizzling_viewDidAppear:animated];
}

-(void)swizzling_viewDidDisappear:(BOOL)animated
{
    NSLog(@"swizzling_viewDidDisappear: %@", [self class]);
    [self swizzling_viewDidDisappear:animated];
}

-(void)swizzling_dealloc
{
    NSLog(@"swizzling_dealloc: %@", [self class]);
    [self swizzling_dealloc];
}

@end
