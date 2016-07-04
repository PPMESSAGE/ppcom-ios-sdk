//
//  PPWebSocketPool.h
//  PPMessage
//
//  Created by PPMessage on 4/20/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRWebSocket.h"

@class PPWebSocketPool, PPSDK;

/**
 * delegate websocket behaviour
 */
@protocol PPWebSocketPoolDelegate <NSObject>

@required
- (void)didMessageArrived:(PPWebSocketPool*)webSocketPool message:(id)message;

@optional
- (void)didSocketOpened:(PPWebSocketPool*)webSocketPool;
- (void)didSocketAuthed:(PPWebSocketPool*)webSocketPool;
- (void)didSocketClosed:(PPWebSocketPool*)webSocketPool;
- (void)didSocketConnecting:(PPWebSocketPool*)webSocketPool;
- (void)didSocketMeetError:(PPWebSocketPool*)webSocketPool
                     error:(NSError*)error;

@end

/**
 * Manage websocket open close reconnect
 *
 * We maintain a Queue to manage webSockets:
 * 
 * ------------------------------------------------------
 *   <- (CLOSED | CLOSING )  ws1 | ws2 | ws3 | <- (NEW)
 * ------------------------------------------------------
 *
 */
@interface PPWebSocketPool : NSObject

/** try auto reconnect when websocket loss connect, default is YES **/
@property (nonatomic) BOOL autoReconnectWhenLossConnect;

/** maximum try re-connect limit, default is 3 **/
@property (nonatomic) NSInteger maximumTryReconnectLimit;

@property (nonatomic, weak) id<PPWebSocketPoolDelegate> webSocketPoolDelegate;

- (instancetype)initWithPPSDK:(PPSDK*)sdk;

- (BOOL)send:(NSString*)messages;

- (BOOL)isOpen;
- (void)open;
- (void)close;
- (void)reconnect;

@end
