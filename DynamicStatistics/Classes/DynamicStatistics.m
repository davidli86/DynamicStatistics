//
//  DynamicStatistics.m
//  Pods
//
//  Created by David Li on 16/10/2017.
//
//

#import "DynamicStatistics.h"

#define PlistFileName   @"DynamicStatistics"

static DynamicStatistics *_instance;

@interface DynamicStatistics (){
    NSDictionary    *_eventDict;
    DSEventLogBlock _eventLogBlock;
    BOOL            _logAllEvent;
    BOOL            _logAllPageEvent;
}
@end

@implementation DynamicStatistics

+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DynamicStatistics alloc] init];
    });
    return _instance;
}

-(void)setupWithPlist:(NSString *)fileName andEventLogBlock:(DSEventLogBlock)block
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    if (plistPath == nil) {
        NSLog(@"Plist file doesn't exist: %@", fileName);
        return;
    }
    [self setupWithPlistFilePath:plistPath andEventLogBlock:block];
}

-(void)setupWithUrlString:(NSString *)urlString andEventLogBlock:(DSEventLogBlock)block
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:PlistFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        [self setupWithPlist:plistPath andEventLogBlock:block];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Network error occur when reading plist from %@.\n%@", urlString, error);
        }else{
            NSError *aError;
            NSString *plistStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [plistStr writeToFile:plistPath atomically:YES encoding:NSUTF8StringEncoding error:&aError];
            if (aError) {
                NSLog(@"Error occur when writing plist to file.\n%@", aError);
            }else{
                [self setupWithPlistFilePath:plistPath andEventLogBlock:block];
            }
        }
    }];
    [task resume];
}

-(void)setupWithPlistFilePath:(NSString *)plistPath andEventLogBlock:(DSEventLogBlock)block
{
    NSArray *configArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    if (configArray == nil) {
        NSLog(@"Error occur when reading plist file: %@", plistPath);
        return;
    }
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dict in configArray) {
        if (![dict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Plist data is not correct with: %@", dict);
            continue;
        }
        
        NSString *eventName = [dict objectForKey:@"eventName"];
        NSString *viewPath = [dict objectForKey:@"viewPath"];
        
        if (eventName == nil || viewPath == nil) {
            NSLog(@"Plist data is not correct with: %@", dict);
            continue;
        }
        
        NSString *path = [[viewPath componentsSeparatedByString:@"&&"] firstObject];
        
        DSViewEvent *event = [[DSViewEvent alloc] init];
        event.eventName = eventName;
        event.viewPath = viewPath;
        
        [resultDict setObject:event forKey:path];
    }
    
    _eventDict = resultDict;
    _eventLogBlock = block;
}

-(void)setLogAllEvent:(BOOL)logAllEvent
{
    _logAllEvent = logAllEvent;
}

-(void)setLogAllPageEvent:(BOOL)logAllPageEvent
{
    _logAllPageEvent = logAllPageEvent;
}

-(void)tryToLogEvent:(DSViewEvent *)originalEvent
{
#ifdef DEBUG
    NSLog(@"Try to Log Event\nEvent Type: %@\nView Path: %@", originalEvent.eventTypeDescription, originalEvent.viewPath);
#endif
    
    if (_eventLogBlock == nil) {
        return;
    }
    
    NSArray *viewPathArray = [originalEvent.viewPath componentsSeparatedByString:@"&&"];
    
    if (viewPathArray.count < 2) {
        return;
    }
    
    NSString *viewId = [viewPathArray objectAtIndex:0];
    NSString *indexId = [viewPathArray objectAtIndex:1];
    
    DSViewEvent *event = [_eventDict objectForKey:viewId];
    
    if (_logAllEvent) {
        originalEvent.eventName = event.eventName;
        _eventLogBlock(originalEvent);
        return;
    }
    
    if (_logAllPageEvent) {
        if (originalEvent.eventType == DSEventType_PageCreate ||
            originalEvent.eventType == DSEventType_PageAppear ||
            originalEvent.eventType == DSEventType_PageDisappear ||
            originalEvent.eventType == DSEventType_PageDestroy ||
            originalEvent.eventType == DSEventType_PagePopOut) {
            originalEvent.eventName = event.eventName;
            _eventLogBlock(originalEvent);
            return;
        }
    }
    
    if (event == nil) {
        return;
    }
    
    NSString *cmpIndexId = [[event.viewPath componentsSeparatedByString:@"&&"] objectAtIndex:1];
    
    NSArray *indexArray = [indexId componentsSeparatedByString:@"-"];
    NSArray *cmpIndexArray = [cmpIndexId componentsSeparatedByString:@"-"];
    
    if (indexArray.count != cmpIndexArray.count) {
        return ;
    }
    
    for (int i = 0; i < indexArray.count; i++) {
        NSArray *indexes = [[indexArray objectAtIndex:i] componentsSeparatedByString:@":"];
        NSArray *cmpIndexes = [[cmpIndexArray objectAtIndex:i] componentsSeparatedByString:@":"];
        
        if (indexes.count != cmpIndexes.count) {
            return;
        }
        
        for (int j = 0; j < indexes.count; j++) {
            NSString *index = [indexes objectAtIndex:j];
            NSString *cmpIndex = [cmpIndexes objectAtIndex:j];
            
            if ([cmpIndex isEqualToString:@"*"]) {
                continue;
            }
            
            if ([cmpIndex isEqualToString:index]) {
                continue;
            }
        }
    }
    
    originalEvent.eventName = event.eventName;
    _eventLogBlock(originalEvent);
}

@end
