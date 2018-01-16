//
//  NSObject+DSRuntimeAdditionsTests.m
//  DynamicStatistics_Tests
//
//  Created by David Li on 16/01/2018.
//  Copyright © 2018 492334421@qq.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+DSForUnitTest.h"
#import <objc/runtime.h>
#import <DynamicStatistics_OC/NSObject+DSRuntimeAdditions.h>

@interface NSObject_DSRuntimeAdditionsTests : XCTestCase

@end

@implementation NSObject_DSRuntimeAdditionsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSwizzleInstanceSelectorWithSelector
{
    IMP descriptionOriginalImp = class_getMethodImplementation([NSObject class], @selector(description));
    IMP swDescriptionOriginalImp = class_getMethodImplementation([NSObject class], @selector(sw_description));
    [NSObject swizzleInstanceSelector:@selector(description) with:@selector(sw_description)];
    IMP descriptionSwizzledImp = class_getMethodImplementation([NSObject class], @selector(description));
    IMP swDescriptionSwizzledImp = class_getMethodImplementation([NSObject class], @selector(sw_description));
    
    XCTAssertEqual(descriptionOriginalImp, swDescriptionSwizzledImp, @"Swizzle instance selector with selector failed");
    XCTAssertEqual(swDescriptionOriginalImp, descriptionSwizzledImp, @"Swizzle instance selector with selector failed");
}

- (void)testSwizzleClassSelectorWithSelector
{
    Class class = object_getClass((id)[NSObject class]);

    IMP descriptionOriginalImp = class_getMethodImplementation(class, @selector(description));
    IMP swDescriptionOriginalImp = class_getMethodImplementation(class, @selector(sw_description));
    [NSObject swizzleClassSelector:@selector(description) with:@selector(sw_description)];
    IMP descriptionSwizzledImp = class_getMethodImplementation(class, @selector(description));
    IMP swDescriptionSwizzledImp = class_getMethodImplementation(class, @selector(sw_description));
    
    XCTAssertEqual(descriptionOriginalImp, swDescriptionSwizzledImp, @"Swizzle class selector with selector failed");
    XCTAssertEqual(swDescriptionOriginalImp, descriptionSwizzledImp, @"Swizzle class selector with selector failed");
}

-(void)testSwizzleInstanceSelectorWithIMPAndTypeEncoding
{
    IMP debugDescriptionOriginalImp = class_getMethodImplementation([NSObject class], @selector(debugDescription));
    IMP swImp = (IMP)sw_instance_debugDescription;
    [NSObject swizzleInstanceSelector:@selector(debugDescription) withIMP:swImp andTypeEncoding:"@@:"];
    IMP debugDescriptionSwizzledImp = class_getMethodImplementation([NSObject class], @selector(debugDescription));
    NSString *swizzledSelectorString = [NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(@selector(debugDescription))];
    IMP swDebugDescriptionSwizzledImp = class_getMethodImplementation([NSObject class], NSSelectorFromString(swizzledSelectorString));
    
    XCTAssertEqual(debugDescriptionOriginalImp, swDebugDescriptionSwizzledImp, @"Swizzle instance selector with imp and type encoding failed");
    XCTAssertEqual(swImp, debugDescriptionSwizzledImp, @"Swizzle instance selector with imp and type encoding failed");
}

-(void)testSwizzleClassSelectorWithIMPAndTypeEncoding
{
    Class class = object_getClass((id)[NSObject class]);

    IMP debugDescriptionOriginalImp = class_getMethodImplementation(class, @selector(debugDescription));
    IMP swImp = (IMP)sw_class_debugDescription;
    [NSObject swizzleClassSelector:@selector(debugDescription) withIMP:swImp andTypeEncoding:"@@:"];
    IMP debugDescriptionSwizzledImp = class_getMethodImplementation(class, @selector(debugDescription));
    NSString *swizzledSelectorString = [NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(@selector(debugDescription))];
    IMP swDebugDescriptionSwizzledImp = class_getMethodImplementation(class, NSSelectorFromString(swizzledSelectorString));
    
    XCTAssertEqual(debugDescriptionOriginalImp, swDebugDescriptionSwizzledImp, @"Swizzle class selector with imp and type encoding failed");
    XCTAssertEqual(swImp, debugDescriptionSwizzledImp, @"Swizzle class selector with imp and type encoding failed");
}
@end

