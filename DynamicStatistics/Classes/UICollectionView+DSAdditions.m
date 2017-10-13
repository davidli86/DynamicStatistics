//
//  UICollectionView+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UICollectionView+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSEvent.h"
#import <objc/message.h>

void swizzling_collectionView_didSelectItemAtIndexPath(id self, SEL _cmd, UICollectionView *collectionView, NSIndexPath *indexPath)
{
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, swizzledSEL, collectionView, indexPath);
    
    DSEvent *event = [DSEvent eventWithView:[collectionView cellForItemAtIndexPath:indexPath] andIndexPath:indexPath];
    NSLog(@"\nEvent Type: %@\nView Path: %@", event.eventTypeDescription, event.viewPath);
}

@implementation UICollectionView (DSAdditions)

+(void)load
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
