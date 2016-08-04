//
//  PPWebSocket.h
//  Pods
//
//  Created by Jin He on 8/2/16.
//
//

#import <Foundation/Foundation.h>

@class PPWebSocket, PPSDK;

/**
 * delegate websocket behaviour
 */
@protocol PPWebSocketDelegate <NSObject>

@required
- (void)didMessageArrived:(PPWebSocket*)webSocket message:(id)message;

@optional
- (void)didSocketOpened:(PPWebSocket*)webSocket;
- (void)didSocketAuthed:(PPWebSocket*)webSocket;
- (void)didSocketClosed:(PPWebSocket*)webSocket;
- (void)didSocketConnecting:(PPWebSocket*)webSocket;
- (void)didSocketFail:(PPWebSocket*)webSocket withError:(NSError*)error;

@end

@interface PPWebSocket : NSObject

@property (nonatomic, weak) id<PPWebSocketDelegate> delegate;

- (instancetype)initWithPPSDK:(PPSDK*)sdk;

- (BOOL)send:(NSString*)messages;

- (BOOL)isOpen;
- (void)open;
- (void)close;
- (void)reconnect;

@end
