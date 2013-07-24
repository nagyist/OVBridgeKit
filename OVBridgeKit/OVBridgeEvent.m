//
//  OVEvent.m
//  OVBridge
//
//  Created by Vinson.D.Warm on 7/19/13.
//  Copyright (c) 2013 Vinson.D.Warm. All rights reserved.
//

#import "OVBridgeEvent.h"

@implementation OVBridgeEvent

@synthesize eventId = _eventId;
@synthesize eventLabel = _eventLabel;
@synthesize senderId = _senderId;

+ (id)eventWithId:(NSInteger)eventId
       eventLabel:(NSString *)eventLabel
         senderId:(NSString *)senderId {
    OVBridgeEvent *event = [[OVBridgeEvent alloc] init];
    event.eventId = eventId;
    event.eventLabel = eventLabel;
    event.senderId = senderId;
    return event;
}

@end
