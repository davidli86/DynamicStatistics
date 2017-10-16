//
//  DSEvent.m
//  Pods
//
//  Created by David Li on 12/10/2017.
//
//

#import "DSViewEvent.h"
#import "UIView+DSAdditions.h"

@implementation DSViewEvent

-(NSString *)eventTypeDescription;
{
    NSString *eventStr = @"";
    switch (self.eventType) {
        case DSEventType_Click:
            eventStr = @"Click";
            break;
        case DSEventType_Scroll:
            eventStr = @"Scroll";
            break;
        case DSEventType_GestureTap:
            eventStr = @"Tap Guesture";
            break;
        case DSEventType_GesturePinch:
            eventStr = @"Pinch Gesture";
            break;
        case  DSEventType_GestureRotation:
            eventStr = @"Rotation Gesture";
            break;
        case DSEventType_GestureSwipe:
            eventStr = @"Swipe Gesture";
            break;
        case DSEventType_GestureScreenEdgePan:
            eventStr = @"Screen Edge Pan Gesture";
            break;
        case DSEventType_GestureLongPress:
            eventStr = @"Long Press Gesture";
            break;
        case DSEventType_PageCreate:
            eventStr = @"Page Create";
            break;
        case DSEventType_PageAppear:
            eventStr = @"Page Appear";
            break;
        case DSEventType_PageDisappear:
            eventStr = @"Page Disappear";
            break;
        case DSEventType_PageDestroy:
            eventStr = @"Page Destroy";
            break;
        case DSEventType_PagePopOut:
            eventStr = @"Page Pop Out";
            break;
        case DSEventType_StartLoadUrl:
            eventStr = @"Start Load Url";
            break;
        case DSEventType_SucceedLoadUrl:
            eventStr = @"Succeed Load Url";
            break;
        case  DSEventType_FailLoadUrl:
            eventStr = @"Fail Load Url";
            break;
        case DSEventType_Unknown:
            eventStr = @"Unknown";
            break;
        default:
            break;
    }
    
    return eventStr;
}

#pragma mark - Public Constructer
+(DSViewEvent *)eventWithView:(UIView *)view
{
    NSInteger index = 0;
    if (view.superview) {
        index = [view.superview.subviews indexOfObject:view];
    }
    
    return [self eventWithView:view andIndexStr:[NSString stringWithFormat:@"%ld", index] eventType:DSEventType_Click];
}

+(DSViewEvent *)eventWithView:(UIView *)view andIndex:(NSInteger)index
{
    NSString *indexStr = [NSString stringWithFormat:@"%ld", index];
    if ([view isKindOfClass:[UIAlertView class]] || [view isKindOfClass:[UIActionSheet class]]) {
        return [self eventWithNonView:view andIndexStr:indexStr eventType:DSEventType_Click];
    }else{
        return [self eventWithView:view andIndexStr:indexStr eventType:DSEventType_Click];
    }
}

+(DSViewEvent *)eventWithView:(UIView *)view andIndexPath:(NSIndexPath *)indexPath
{
    return [self eventWithView:view andIndexStr:[NSString stringWithFormat:@"%ld:%ld", indexPath.section, indexPath.row] eventType:DSEventType_Click];
}

+(DSViewEvent *)eventWithNonView:(id)nonView andIndex:(NSInteger)index
{
    return [self eventWithNonView:nonView andIndexStr:[NSString stringWithFormat:@"%ld", index] eventType:DSEventType_Click];
}

+(DSViewEvent *)eventWithNonView:(id)nonView andIndex:(NSInteger)index eventType:(DSEventType)eventType
{
    return [self eventWithNonView:nonView andIndexStr:[NSString stringWithFormat:@"%ld", index] eventType:DSEventType_PagePopOut];
}

+(DSViewEvent *)eventWithView:(UIView *)view andEventType:(DSEventType)eventType
{
    NSInteger index = 0;
    if (view.superview) {
        index = [view.superview.subviews indexOfObject:view];
    }
    return [self eventWithView:view andIndexStr:[NSString stringWithFormat:@"%ld", index] eventType:eventType];
}

+(DSViewEvent *)eventWithViewController:(UIViewController *)viewController andEventType:(DSEventType)eventType
{
    NSInteger index = 0;
    if (viewController.parentViewController) {
        index = [viewController.parentViewController.childViewControllers indexOfObject:viewController];
    }
    DSViewEvent *event = [[DSViewEvent alloc] init];
    event.viewPath = [NSString stringWithFormat:@"%@&&%ld", [viewController class], index];
    event.eventType = eventType;
    return event;
}

#pragma mark - Private Constructer

+(DSViewEvent *)eventWithNonView:(id)nonView andIndexStr:(NSString *)indexStr eventType:(DSEventType)eventType
{
    NSMutableString *viewId = [NSMutableString stringWithString:NSStringFromClass([nonView class])];
    
    id title = nil;
    id tag = nil;
    @try {
        title = [nonView valueForKey:@"title"];
        if (title == nil) {
            title = [nonView valueForKeyPath:@"titleLabel.text"];
        }
        tag = [nonView valueForKey:@"tag"];
    } @catch (NSException *exception) {
    }
    
    if (title) {
        if ([title isKindOfClass:[NSString class]]) {
            title = [((NSString *)title) stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            title = [((NSString *)title) stringByReplacingOccurrencesOfString:@"&&" withString:@"_"];
        }
        [viewId appendString:@"_"];
        [viewId appendFormat:@"%@", title];
    }
    
    if (tag) {
        if ([tag isKindOfClass:[NSString class]]) {
            tag = [((NSString *)tag) stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            tag = [((NSString *)tag) stringByReplacingOccurrencesOfString:@"&&" withString:@"_"];
        }
        [viewId appendString:@"_"];
        [viewId appendFormat:@"%@", tag];
    }
    
    return [self eventWithViewId:viewId andIndexStr:indexStr eventType:eventType];
}


+(DSViewEvent *)eventWithViewId:(NSString *)viewId andIndexStr:(NSString *)indexStr eventType:(DSEventType)eventType
{
    NSMutableArray *viewClassPath = [NSMutableArray array];
    NSMutableArray *viewIndexPath = [NSMutableArray array];
    
    [viewClassPath addObject:viewId];
    [viewIndexPath addObject:indexStr];
    
    UIViewController *topVC = [self topViewController];
    while ([topVC isKindOfClass:[UIAlertController class]]) {
        topVC = topVC.presentingViewController;
    }
    
    if (topVC == nil) {
        return nil;
    }
    
    NSInteger index = 0;
    [viewClassPath addObject:NSStringFromClass([topVC class])];
    if (topVC.parentViewController) {
        index = [topVC.parentViewController.childViewControllers indexOfObject:topVC];
        [viewIndexPath addObject:@(index)];
    }else{
        [viewIndexPath addObject:@(0)];
    }
    
    NSString *classPathStr = [viewClassPath.reverseObjectEnumerator.allObjects componentsJoinedByString:@"-"];
    NSString *indexPathStr = [viewIndexPath.reverseObjectEnumerator.allObjects componentsJoinedByString:@"-"];
    NSString *viewPath = [NSString stringWithFormat:@"%@&&%@", classPathStr, indexPathStr];
    
    DSViewEvent *event = [[DSViewEvent alloc] init];
    event.viewPath = viewPath;
    event.eventType = eventType;
    
    return event;
}

+(DSViewEvent *)eventWithView:(UIView *)view andIndexStr:(NSString *)indexStr eventType:(DSEventType)eventType
{
    NSMutableArray *viewClassPath = [NSMutableArray array];
    NSMutableArray *viewIndexPath = [NSMutableArray array];
    
    [viewClassPath addObject:NSStringFromClass([view class])];
    [viewIndexPath addObject:indexStr];
    
    UIViewController *parentVC = [view parentViewController];
    
    if (!parentVC) {
        return nil;
    }
    
    if ([parentVC isKindOfClass:[UINavigationController class]] || [parentVC isKindOfClass:[UITabBarController class]]) {
        return [self eventWithNonView:view andIndexStr:indexStr eventType:eventType];
    }
    
    NSInteger index = 0;
    while (view != parentVC.view) {
        view = view.superview;
        if (view) {
            index = [view.superview.subviews indexOfObject:view];
            
            [viewClassPath addObject:NSStringFromClass([view class])];
            [viewIndexPath addObject:@(index)];
        }else{
            break;
        }
    }
    [viewClassPath addObject:NSStringFromClass([parentVC class])];
    if (parentVC.parentViewController) {
        index = [parentVC.parentViewController.childViewControllers indexOfObject:parentVC];
        [viewIndexPath addObject:@(index)];
    }else{
        [viewIndexPath addObject:@(0)];
    }
    
    NSString *classPathStr = [viewClassPath.reverseObjectEnumerator.allObjects componentsJoinedByString:@"-"];
    NSString *indexPathStr = [viewIndexPath.reverseObjectEnumerator.allObjects componentsJoinedByString:@"-"];
    NSString *viewPath = [NSString stringWithFormat:@"%@&&%@", classPathStr, indexPathStr];
    
    DSViewEvent *event = [[DSViewEvent alloc] init];
    event.viewPath = viewPath;
    event.eventType = eventType;
    
    return event;
}


#pragma mark - Get Top ViewController
+ (UIViewController *) topViewController {
    UIViewController *baseVC = [UIApplication sharedApplication].delegate.window.rootViewController;;
    return [self topViewControllerFrom:baseVC];
}


+ (UIViewController *) topViewControllerFrom:(UIViewController *)baseVC {
    if ([baseVC isKindOfClass:[UINavigationController class]]) {
        return [self topViewControllerFrom:((UINavigationController *)baseVC).visibleViewController];
    }
    
    if ([baseVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedTVC = ((UITabBarController*)baseVC).selectedViewController;
        if (selectedTVC) {
            return [self topViewControllerFrom:selectedTVC];
        }
    }
    
    if (baseVC.presentedViewController) {
        return [self topViewControllerFrom:baseVC.presentedViewController];
    }
    
    return baseVC;
}

@end
