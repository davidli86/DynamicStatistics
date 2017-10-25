//
//  DynamicStatistics+DSPrivate.h
//  Pods
//
//  Created by David Li on 25/10/2017.
//
//

#import "DynamicStatistics.h"

@interface DynamicStatistics (DSPrivate)

-(void)tryToLogEvent:(DSViewEvent *)event;
+(void)registerClass:(Class)aClass;

@end
