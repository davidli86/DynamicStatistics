//
//  DSViewEvent.h
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

@interface DSViewEvent : NSObject

@property(nonatomic, strong) NSString               *eventName;
@property(nonatomic, strong) NSString               *viewPath;
@property(nonatomic, assign) DSEventType            eventType;
@property(nonatomic, assign, readonly) NSString     *eventTypeDescription;

//for UIView
+(DSViewEvent *)eventWithView:(UIView *)view;
+(DSViewEvent *)eventWithView:(UIView *)view andIndex:(NSInteger)index;
+(DSViewEvent *)eventWithView:(UIView *)view andIndexPath:(NSIndexPath *)indexPath;
+(DSViewEvent *)eventWithView:(UIView *)view andEventType:(DSEventType)eventType;

//for UIAlertAction & UIBarButtonItem
+(DSViewEvent *)eventWithNonView:(id)nonView andIndex:(NSInteger)index;
+(DSViewEvent *)eventWithNonView:(id)nonView andIndex:(NSInteger)index eventType:(DSEventType)eventType;

//for UIViewController
+(DSViewEvent *)eventWithViewController:(UIViewController *)viewController andEventType:(DSEventType)eventType;

@end
