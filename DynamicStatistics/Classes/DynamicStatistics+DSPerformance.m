//
//  DynamicStatistics+DSPerformance.m
//  Pods
//
//  Created by David Li on 19/10/2017.
//
//

#import "DynamicStatistics+DSPerformance.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DynamicStatistics+DSPrivate.h"

@implementation DynamicStatistics (DSPerformance)

+(void)load
{
#ifdef DEBUG
    [self swizzleInstanceSelector:@selector(tryToLogEvent:) with:@selector(swizzling_tryToLogEvent:)];
#endif
}

-(void)swizzling_tryToLogEvent:(DSViewEvent *)event
{
    NSDate *start = [NSDate date];
    [self swizzling_tryToLogEvent:event];
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Try to log event with time: %.2fms", delta * 1000);
}

@end
