//
//  DynamicStatistics.h
//  Pods
//
//  Created by David Li on 16/10/2017.
//
//

#import <Foundation/Foundation.h>
#import "DSViewEvent.h"

typedef void(^DSEventLogBlock)(DSViewEvent *event);

@interface DynamicStatistics : NSObject

+(instancetype)sharedInstance;

-(void)setupWithPlist:(NSString *)fileName andEventLogBlock:(DSEventLogBlock)block;
-(void)setupWithUrlString:(NSString *)urlString andEventLogBlock:(DSEventLogBlock)block;

@end
