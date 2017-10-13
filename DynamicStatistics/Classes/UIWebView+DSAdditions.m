//
//  UIWebView+DSAdditions.m
//  Pods
//
//  Created by David Li on 09/10/2017.
//
//

#import "UIWebView+DSAdditions.h"
#import "NSObject+DSRuntimeAdditions.h"
#import "DSEvent.h"
#import <objc/message.h>

void swizzling_webViewDidStartLoad(id self, SEL _cmd, UIWebView *webView)
{
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, webView);
    
    DSEvent *event = [DSEvent eventWithView:webView andEventType:DSEventType_StartLoadUrl];
    NSLog(@"\nEvent Type: %@\nView Path: %@", event.eventTypeDescription, event.viewPath);
}

void swizzling_webViewDidFinishLoad(id self, SEL _cmd, UIWebView *webView)
{
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id))objc_msgSend)(self, swizzledSEL, webView);
    
    DSEvent *event = [DSEvent eventWithView:webView andEventType:DSEventType_SucceedLoadUrl];
    NSLog(@"\nEvent Type: %@\nView Path: %@", event.eventTypeDescription, event.viewPath);
}

void swizzling_webView_didFailLoadWithError(id self, SEL _cmd, UIWebView *webView, NSError *error)
{
    SEL swizzledSEL = NSSelectorFromString([NSString stringWithFormat:@"%@%@", SwizzlingMethodPrefix, NSStringFromSelector(_cmd)]);
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, swizzledSEL, webView, error);
    
    DSEvent *event = [DSEvent eventWithView:webView andEventType:DSEventType_FailLoadUrl];
    NSLog(@"\nEvent Type: %@\nView Path: %@", event.eventTypeDescription, event.viewPath);
}

@implementation UIWebView (DSAdditions)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setDelegate:) with:@selector(swizzling_setDelegate:)];
    });
}

-(void)swizzling_setDelegate:(id<UIWebViewDelegate>)delegate
{
    [[delegate class] swizzleInstanceSelector:@selector(webViewDidStartLoad:) withIMP:(IMP)swizzling_webViewDidStartLoad andTypeEncoding:"v@:@"];
    [[delegate class] swizzleInstanceSelector:@selector(webViewDidFinishLoad:) withIMP:(IMP)swizzling_webViewDidFinishLoad andTypeEncoding:"v@:@"];
    [[delegate class] swizzleInstanceSelector:@selector(webView:didFailLoadWithError:) withIMP:(IMP)swizzling_webView_didFailLoadWithError andTypeEncoding:"v@:@@"];

    [self swizzling_setDelegate:delegate];
}

@end
