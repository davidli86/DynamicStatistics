//
//  DSViewEvent+DSPerformance.m
//  Pods
//
//  Created by David Li on 19/10/2017.
//
//

#import "DSViewEvent+DSPerformance.h"
#import "NSObject+DSRuntimeAdditions.h"

@implementation DSViewEvent (DSPerformance)

+(void)load
{
#ifdef DEBUG
    [self swizzleClassSelector:@selector(eventWithView:) with:@selector(swizzling_eventWithView:)];
    [self swizzleClassSelector:@selector(eventWithView:andIndex:) with:@selector(swizzling_eventWithView:andIndex:)];
    [self swizzleClassSelector:@selector(eventWithView:andIndexPath:) with:@selector(swizzling_eventWithView:andIndexPath:)];
    [self swizzleClassSelector:@selector(eventWithView:andEventType:) with:@selector(swizzling_eventWithView:andEventType:)];
    [self swizzleClassSelector:@selector(eventWithNonView:andIndex:) with:@selector(swizzling_eventWithNonView:andIndex:)];
    [self swizzleClassSelector:@selector(eventWithNonView:andIndex:eventType:) with:@selector(swizzling_eventWithNonView:andIndex:eventType:)];
    [self swizzleClassSelector:@selector(eventWithViewController:andEventType:) with:@selector(swizzling_eventWithViewController:andEventType:)];
#endif
}

//for UIView
+(DSViewEvent *)swizzling_eventWithView:(UIView *)view
{
    NSDate *start = [NSDate date];
    DSViewEvent *event = [self swizzling_eventWithView:view];
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Generate event with time: %.2fms", delta * 1000);
    return event;
}

+(DSViewEvent *)swizzling_eventWithView:(UIView *)view andIndex:(NSInteger)index
{
    NSDate *start = [NSDate date];
    DSViewEvent *event = [self swizzling_eventWithView:view andIndex:index];
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Generate Event with time: %.2fms", delta * 1000);
    return event;
}

+(DSViewEvent *)swizzling_eventWithView:(UIView *)view andIndexPath:(NSIndexPath *)indexPath
{
    NSDate *start = [NSDate date];
    DSViewEvent *event = [self swizzling_eventWithView:view andIndexPath:indexPath];
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Generate Event with time: %.2fms", delta * 1000);
    return event;
}

+(DSViewEvent *)swizzling_eventWithView:(UIView *)view andEventType:(DSEventType)eventType
{
    NSDate *start = [NSDate date];
    DSViewEvent *event = [self swizzling_eventWithView:view andEventType:eventType];
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Generate Event with time: %.2fms", delta * 1000);
    return event;
}

//for UIAlertAction & UIBarButtonItem
+(DSViewEvent *)swizzling_eventWithNonView:(id)nonView andIndex:(NSInteger)index
{
    NSDate *start = [NSDate date];
    DSViewEvent *event = [self swizzling_eventWithNonView:nonView andIndex:index];
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Generate Event with time: %.2fms", delta * 1000);
    return event;
}

+(DSViewEvent *)swizzling_eventWithNonView:(id)nonView andIndex:(NSInteger)index eventType:(DSEventType)eventType
{
    NSDate *start = [NSDate date];
    DSViewEvent *event = [self swizzling_eventWithNonView:nonView andIndex:index eventType:eventType];
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Generate Event with time: %.2fms", delta * 1000);
    return event;
}

//for UIViewController
+(DSViewEvent *)swizzling_eventWithViewController:(UIViewController *)viewController andEventType:(DSEventType)eventType
{
    NSDate *start = [NSDate date];
    DSViewEvent *event = [self swizzling_eventWithViewController:viewController andEventType:eventType];
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Generate Event with time: %.2fms", delta * 1000);
    return event;
}

@end
