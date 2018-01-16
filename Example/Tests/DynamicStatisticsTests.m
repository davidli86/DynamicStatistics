//
//  DSDynamicStatisticsTests.m
//  DynamicStatistics_Tests
//
//  Created by David Li on 15/01/2018.
//  Copyright © 2018 492334421@qq.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <DynamicStatistics_OC/DynamicStatistics.h>

@interface DynamicStatisticsTests : XCTestCase{
    NSString *_userIdentifier;
}

@end

@implementation DynamicStatisticsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _userIdentifier = [DynamicStatistics userIdentifier];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testUserIdentifierIsStable
{
    NSString *tmpUserIdentifier = [DynamicStatistics userIdentifier];
    XCTAssertNotNil(tmpUserIdentifier, @"User identifer should not be nil");
    XCTAssertTrue([tmpUserIdentifier isEqualToString:_userIdentifier], @"User identifier should be stable");
}




@end
