//
//  UICollectionView+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UICollectionView+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSViewEvent.h"
#import <objc/message.h>
#import "DynamicStatistics+DSPrivate.h"

void swizzling_collectionView_didSelectItemAtIndexPath(id self, SEL _cmd, UICollectionView *collectionView, NSIndexPath *indexPath)
{
    DSViewEvent *event = [DSViewEvent eventWithView:[collectionView cellForItemAtIndexPath:indexPath] andIndexPath:indexPath];
    [[DynamicStatistics sharedInstance] tryToLogEvent:event];
    
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    if ([self respondsToSelector:swizzledSEL]) {
        ((void(*)(id, SEL, id, id))objc_msgSend)(self, swizzledSEL, collectionView, indexPath);
    }
}

@implementation UICollectionView (DSAdditions)

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

-(void)swizzling_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    [[delegate class] swizzleInstanceSelector:@selector(collectionView:didSelectItemAtIndexPath:) withIMP:(IMP)swizzling_collectionView_didSelectItemAtIndexPath andTypeEncoding:"v@:@@"];
    [self swizzling_setDelegate:delegate];
}

@end
