//
//  UIGestureRecognizer+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIGestureRecognizer+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import <objc/message.h>

void swizzling_targetAction(id self, SEL _cmd, UIGestureRecognizer *sender){
    NSLog(@"swizzling_targetAction: %@, sender: %@", [self class], [sender class]);
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, sender);
}

@implementation UIGestureRecognizer (DSAdditions)

+(void)load
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
