//
//  NSObject+DSForUnitTest.h
//  DynamicStatistics_Example
//
//  Created by David Li on 16/01/2018.
//  Copyright © 2018 492334421@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString* sw_instance_debugDescription(id self, SEL _cmd);
NSString* sw_class_debugDescription(id self, SEL _cmd);

@interface NSObject (DSForUnitTest)

- (NSString *)sw_description;
+ (NSString *)sw_description;

@end
