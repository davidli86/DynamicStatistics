//
//  DSUserIdentifier.m
//  DynamicStatistics
//
//  Created by David Li on 10/01/2018.
//

#import "DSUserIdentifier.h"
#import "SAMKeychain.h"

#define kKeyChainServiceName    @"KeyChainServiceName_DynamicStatistics"
#define kKeyChainAccount        @"KeyChainAccount_DynamicStatistics"

@implementation DSUserIdentifier

+(NSString *)userUUID{
    NSString *uuid = [SAMKeychain passwordForService:kKeyChainServiceName account:kKeyChainAccount];
    if (uuid == nil || uuid.length == 0) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, theUUID));
        CFRelease(theUUID);
        [SAMKeychain setPassword:uuid forService:kKeyChainServiceName account:kKeyChainAccount];
    }
    return uuid;
}

@end
