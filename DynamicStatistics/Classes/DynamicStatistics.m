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
static NSMutableArray    *_swizzleClasses;

@interface DynamicStatistics (){
    NSDictionary    *_exactEventDict;
    NSDictionary    *_wildcardEventDict;

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

+(void)registerClass:(Class)aClass;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _swizzleClasses = [NSMutableArray array];
    });
    if (aClass != NULL) {
        [_swizzleClasses addObject:aClass];
    }
}

-(void)tryToLoadAllSwizzle
{
    if (_exactEventDict.count > 0 || _wildcardEventDict > 0 || _logAllEvent || _logAllPageEvent) {
        SEL loadSwizzle = NSSelectorFromString(@"loadSwizzle");
        for (id aClass in _swizzleClasses) {
            if ([aClass respondsToSelector:loadSwizzle]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [aClass performSelector:loadSwizzle];
#pragma clang diagnostic pop

            }
        }
    }
}

-(void)setupWithPlist:(NSString *)fileName andEventLogBlock:(DSEventLogBlock)block
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    if (plistPath == nil) {
        NSLog(@"Plist file doesn't exist: %@", fileName);
        return;
    }
    [self setupWithPlistFilePath:plistPath andEventLogBlock:block];
    [self tryToLoadAllSwizzle];
}

-(void)setupWithUrlString:(NSString *)urlString andEventLogBlock:(DSEventLogBlock)block
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:PlistFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        [self setupWithPlistFilePath:plistPath andEventLogBlock:block];
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
        [self tryToLoadAllSwizzle];
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
    
    NSMutableDictionary *exactDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *wildcardDict = [NSMutableDictionary dictionary];
    
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
        
        DSViewEvent *event = [[DSViewEvent alloc] init];
        event.eventName = eventName;
        event.viewPath = viewPath;
        
        if (![viewPath containsString:@"*"]) {
            [exactDict setObject:event forKey:viewPath];
            continue;
        }
        
        NSString *path = [[viewPath componentsSeparatedByString:@"&&"] firstObject];
        if ([wildcardDict objectForKey:path] == nil) {
            [wildcardDict setObject:path forKey:[NSMutableArray array]];
        }
        [((NSMutableArray *)[wildcardDict objectForKey:path]) addObject:event];
    }
    
    _exactEventDict = exactDict;
    _wildcardEventDict = wildcardDict;
    _eventLogBlock = block;
}

-(void)setLogAllEvent:(BOOL)logAllEvent
{
    _logAllEvent = logAllEvent;
    [self tryToLoadAllSwizzle];
}

-(void)setLogAllPageEvent:(BOOL)logAllPageEvent
{
    _logAllPageEvent = logAllPageEvent;
    [self tryToLoadAllSwizzle];
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
    
    DSViewEvent *exactEvent = [_exactEventDict objectForKey:originalEvent.viewPath];
    NSArray *wildcardEvents = [_wildcardEventDict objectForKey:viewId];
    
    BOOL found = NO;
    
    if (exactEvent) {//无通配符直接找到
        
        originalEvent.eventName = exactEvent.eventName;
        found = YES;
        
    }else if (wildcardEvents){//找到有通配符的，再详细比较index
        
        DSViewEvent *eventIsEqual = nil;
        
        for (DSViewEvent *event in wildcardEvents) {
            NSString *cmpIndexId = [[event.viewPath componentsSeparatedByString:@"&&"] objectAtIndex:1];
            
            NSArray *indexArray = [indexId componentsSeparatedByString:@"-"];
            NSArray *cmpIndexArray = [cmpIndexId componentsSeparatedByString:@"-"];
            
            //path长度不相等
            if (indexArray.count != cmpIndexArray.count) {
                continue ;
            }
            
            BOOL isEqual = YES;
            for (int i = 0; i < indexArray.count && isEqual; i++) {
                
                //如果是indexpath，拆开再比较
                NSArray *indexes = [[indexArray objectAtIndex:i] componentsSeparatedByString:@":"];
                NSArray *cmpIndexes = [[cmpIndexArray objectAtIndex:i] componentsSeparatedByString:@":"];
                
                if (indexes.count != cmpIndexes.count) {
                    isEqual = NO;
                    break;
                }
                
                for (int j = 0; j < indexes.count; j++) {
                    NSString *index = [indexes objectAtIndex:j];
                    NSString *cmpIndex = [cmpIndexes objectAtIndex:j];
                    
                    if (![cmpIndex isEqualToString:@"*"] && ![cmpIndex isEqualToString:index]) {
                        isEqual = NO;
                        break;
                    }
                }
            }
            if (isEqual) {
                eventIsEqual = event;
                break;
            }
        }
        if (eventIsEqual) {
            originalEvent.eventName = eventIsEqual.eventName;
            found = YES;
        }
        
    }
    
    if (found || _logAllEvent) {
        
        _eventLogBlock(originalEvent);
        
    }else if (_logAllPageEvent) {
        if (originalEvent.eventType == DSEventType_PageCreate ||
            originalEvent.eventType == DSEventType_PageAppear ||
            originalEvent.eventType == DSEventType_PageDisappear ||
            originalEvent.eventType == DSEventType_PageDestroy ||
            originalEvent.eventType == DSEventType_PagePopOut) {
            
            _eventLogBlock(originalEvent);
            
        }
    }
}

@end
