//
//  UITableView+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UITableView+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSViewEvent.h"
#import <objc/message.h>
#import "DynamicStatistics+DSPrivate.h"

void swizzling_tableView_didSelectRowAtIndexPath (id self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath)
{
    DSViewEvent *event = [DSViewEvent eventWithView:[tableView cellForRowAtIndexPath:indexPath] andIndexPath:indexPath];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    if ([self respondsToSelector:swizzledSEL]) {
        ((void(*)(id, SEL, id, id))objc_msgSend)(self, swizzledSEL, tableView, indexPath);
    }
}

@implementation UITableView (DSAdditions)

+(void)load{
    [DynamicStatistics registerClass:self];
}

+(void)loadSwizzle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setDelegate:) with:@selector(swizzling_setDelegate:)];
    });
}

-(void)swizzling_setDelegate:(id<UITableViewDelegate>)delegate
{
    [[delegate class] swizzleInstanceSelector:@selector(tableView:didSelectRowAtIndexPath:) withIMP:(IMP)swizzling_tableView_didSelectRowAtIndexPath andTypeEncoding:"v@:@@"];
    [self swizzling_setDelegate:delegate];
}


@end


