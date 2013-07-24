//
//  OVEvent.h
//  OVBridge
//
//  Created by Vinson.D.Warm on 7/19/13.
//  Copyright (c) 2013 Vinson.D.Warm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OVBridgeEvent : NSObject

@property (nonatomic, assign) NSInteger eventId;
@property (nonatomic, strong) NSString *eventLabel;
@property (nonatomic, strong) NSString *senderId;

+ (id)eventWithId:(NSInteger)eventId
       eventLabel:(NSString *)eventLabel
         senderId:(NSString *)senderId;

@end