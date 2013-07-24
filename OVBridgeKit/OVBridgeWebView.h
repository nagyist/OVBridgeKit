//
//  OVBridgeWebView.h
//  OVBridge
//
//  Created by Vinson.D.Warm on 7/19/13.
//  Copyright (c) 2013 Vinson.D.Warm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OVBridgeWebView;
@class OVBridgeEvent;

@protocol OVBridgeWebViewDelegate <NSObject>

@optional
- (BOOL)shouldRecieveEvent:(OVBridgeWebView *)webView;
- (void)webView:(OVBridgeWebView *)webView didRecieveEvent:(OVBridgeEvent *)event;
- (BOOL)webView:(OVBridgeWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(OVBridgeWebView *)webView;
- (void)webViewDidFinishLoad:(OVBridgeWebView *)webView;
- (void)webView:(OVBridgeWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface OVBridgeWebView : UIWebView

@property (nonatomic, weak) id<OVBridgeWebViewDelegate> bridgeDelegate;

- (void)registerEvent:(NSInteger)eventId label:(NSString *)eventLabel sender:(NSString *)senderId;
- (void)registerLoadEvent:(NSString *)eventId label:(NSString *)eventLabel;

@end
