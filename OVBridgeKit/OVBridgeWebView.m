//
//  OVBridgeWebView.m
//  OVBridge
//
//  Created by Vinson.D.Warm on 7/19/13.
//  Copyright (c) 2013 Vinson.D.Warm. All rights reserved.
//

#import "OVBridgeWebView.h"
#import "NSString+URI.h"
#import "OVBridgeEvent.h"
#import "JSONKit.h"

#define WINDOW_ON_LOAD_EVENT_ID 1000
#define WINDOW_ON_LOAD_SENDER_ID @"window_on_load_id"
#define WINDOW_ON_LOAD_EVENT_LABEL @"window_on_load_label"

@interface OVBridgeWebView () <UIWebViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *eventMap;

@end

@implementation OVBridgeWebView

@synthesize bridgeDelegate = _bridgeDelegate;
@synthesize eventMap = _eventMap;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.delegate = self;
}

- (void)registerEvent:(NSInteger)eventId label:(NSString *)eventLabel sender:(NSString *)senderId {
    if (![self.eventMap objectForKey:senderId]) {
        [self.eventMap setObject:[NSMutableArray array] forKey:senderId];
    }
    NSDictionary *eventDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eventId], @"eventId", eventLabel, @"eventLabel", nil];
    [[self.eventMap objectForKey:senderId] addObject:eventDic];
    
    [self configureEventHandlerBySenderId:senderId];
}

- (NSMutableDictionary *)eventMap {
    if (!_eventMap) {
        _eventMap = [[NSMutableDictionary alloc] init];
    }
    return _eventMap;
}

- (void)configureEventHandler {
    for (NSString *key in self.eventMap.allKeys) {
        [self configureEventHandlerBySenderId:key];
    }
}

- (void)configureEventHandlerBySenderId:(NSString *)senderId {
    NSString *protocolBody = [NSString stringWithFormat:@"{\"senderId\":\"%@\", \"commandInfo\":%@}", senderId, [[self.eventMap objectForKey:senderId] JSONString]];
    NSString *commandFuncName = [NSString stringWithFormat:@"%@_ov_command", senderId];
    NSString *jsCommand = [NSString stringWithFormat:
                           @"var %@ = document.getElementById('%@');"
                           "if(%@) {"
                           "%@.removeEventListener('click', %@, false);"
                           "var %@ = function(){"
                           "var url='ovbridge://%@';"
                           "document.location = url;"
                           "};"
                           "%@.addEventListener('click', %@, false);"
                           "}",
                           senderId,
                           senderId,
                           senderId,
                           senderId,
                           commandFuncName,
                           commandFuncName,
                           protocolBody,
                           senderId,
                           commandFuncName];
    [self stringByEvaluatingJavaScriptFromString:jsCommand];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (self.bridgeDelegate && [self.bridgeDelegate respondsToSelector:@selector(shouldRecieveEvent:)]) {
        if ([self.bridgeDelegate shouldRecieveEvent:self]) {
            NSString* rurl = [[request URL] absoluteString];
            if ([rurl hasPrefix:@"ovbridge://"]) {
                
                if (self.bridgeDelegate && [self.bridgeDelegate respondsToSelector:@selector(webView:didRecieveEvent:)]) {
                    rurl = [rurl stringByDecodingURLFormat];
                    NSArray *parts = [rurl componentsSeparatedByString:@"://"];
                    NSString *body = [parts objectAtIndex:1];
                    NSDictionary *bodyDic = [body objectFromJSONString];
                    NSString *senderId = [bodyDic objectForKey:@"senderId"];
                    NSArray *commandInfo = [bodyDic objectForKey:@"commandInfo"];
                    for (NSDictionary *eventDic in commandInfo) {
                        OVBridgeEvent *event = [OVBridgeEvent eventWithId:[[eventDic objectForKey:@"eventId"] intValue]
                                                               eventLabel:[eventDic objectForKey:@"eventLabel"]
                                                                 senderId:senderId];
                        [self.bridgeDelegate webView:self
                                     didRecieveEvent:event];
                    }
                }
                return NO;
            }
        }
    }
    
    if (self.bridgeDelegate && [self.bridgeDelegate respondsToSelector:@selector(webView: shouldStartLoadWithRequest:navigationType:)]) {
        return [self.bridgeDelegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (self.bridgeDelegate && [self.bridgeDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        return [self.bridgeDelegate webViewDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.bridgeDelegate && [self.bridgeDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.bridgeDelegate webViewDidFinishLoad:self];
    }
    
    if (self.bridgeDelegate) {
        if ([self.bridgeDelegate webViewShouldHandlerLoadEvent:self]) {
            if ([self.bridgeDelegate respondsToSelector:@selector(webViewDidHandleLoadEvent:)]) {
                [self.bridgeDelegate webViewDidHandleLoadEvent:self];
            }
        }
    }
    
    [self configureEventHandler];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.bridgeDelegate && [self.bridgeDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        return [self.bridgeDelegate webView:self didFailLoadWithError:error];
    }
}

@end
