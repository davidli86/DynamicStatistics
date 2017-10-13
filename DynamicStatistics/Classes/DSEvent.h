//
//  DSEvent.h
//  Pods
//
//  Created by David Li on 12/10/2017.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DSEventType) {
    DSEventType_Click = 0,
    DSEventType_Scroll,
    
    DSEventType_GestureTap,
    DSEventType_GesturePinch,
    DSEventType_GestureRotation,
    DSEventType_GestureSwipe,
    DSEventType_GestureScreenEdgePan,
    DSEventType_GestureLongPress,
    
    DSEventType_PageCreate,
    DSEventType_PageAppear,
    DSEventType_PageDisappear,
    DSEventType_PageDestroy,
    DSEventType_PagePopOut,
    
    DSEventType_StartLoadUrl,
    DSEventType_SucceedLoadUrl,
    DSEventType_FailLoadUrl,
    
    DSEventType_Unknown,
};

@interface DSEvent : NSObject

@property(nonatomic, strong) NSString               *eventName;
@property(nonatomic, strong) NSString               *viewPath;
@property(nonatomic, assign) DSEventType            eventType;
@property(nonatomic, assign, readonly) NSString     *eventTypeDescription;

//for UIView
+(DSEvent *)eventWithView:(UIView *)view;
+(DSEvent *)eventWithView:(UIView *)view andIndex:(NSInteger)index;
+(DSEvent *)eventWithView:(UIView *)view andIndexPath:(NSIndexPath *)indexPath;
+(DSEvent *)eventWithView:(UIView *)view andEventType:(DSEventType)eventType;

//for UIAlertAction & UIBarButtonItem
+(DSEvent *)eventWithNonView:(id)nonView andIndex:(NSInteger)index;
+(DSEvent *)eventWithNonView:(id)nonView andIndex:(NSInteger)index eventType:(DSEventType)eventType;

//for UIViewController
+(DSEvent *)eventWithViewController:(UIViewController *)viewController andEventType:(DSEventType)eventType;

@end
