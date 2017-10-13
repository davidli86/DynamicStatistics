//
//  UIView+DSAdditions.m
//  Pods
//
//  Created by David Li on 12/10/2017.
//
//

#import "UIView+DSAdditions.h"

@implementation UIView (DSAdditions)

- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    if ([responder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)responder;
    }
    return nil;
}

@end
