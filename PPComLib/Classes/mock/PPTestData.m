//
//  PPTestData.m
//  Pods
//
//  Created by PPMessage on 7/5/16.
//
//

#import "PPTestData.h"

#import "PPMessage.h"
#import "PPMessageImageMediaPart.h"
#import "PPMessageFileMediaPart.h"
#import "PPConversationItem.h"

#import "PPApp.h"
#import "PPUser.h"
#import "PPServiceUser.h"

#import "PPSDKUtils.h"

@implementation PPTestData

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PPTestData *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [PPTestData new];
    });
    return instance;
}

- (NSMutableArray*)getConversations {
    NSMutableArray *conversations = [NSMutableArray array];
    [conversations addObject:[self makeConverseationItemWithName:@"Conversation A"
                                         withConversationSummary:@"Conversation Summary A"
                                            withConversationIcon:@"http://images3.wookmark.com/576902_wookmark.png"]];
    [conversations addObject:[self makeConverseationItemWithName:@"Conversation B"
                                        withConversationSummary:@"Conversation Summary B"
                                           withConversationIcon:@"http://images2.wookmark.com/577612_wookmark.jpg"]];
    [conversations addObject:[self makeConverseationItemWithName:@"Conversation C"
                                         withConversationSummary:@"Conversation Summary C"
                                            withConversationIcon:@"http://images3.wookmark.com/577613_wookmark.jpg"]];
    [conversations addObject:[self makeConverseationItemWithName:@"Conversation D"
                                         withConversationSummary:@"Conversation Summary D"
                                            withConversationIcon:@"http://images1.wookmark.com/577614_wookmark.jpg"]];
    [conversations addObject:[self makeConverseationItemWithName:@"Conversation E"
                                         withConversationSummary:@"Conversation Summary E"
                                            withConversationIcon:@"http://images3.wookmark.com/577556_image_86034.633598_.jpg"]];
    
    return conversations;
}

- (NSMutableArray*)getMessages {
    NSMutableArray *messages = [NSMutableArray array];
    
    [messages addObject:[self makePPMessageWithText:@"ABC" withDirection:PPMessageDirectionIncoming]];
    [messages addObject:[self makePPMessageWithText:@"DEF" withDirection:PPMessageDirectionOutgoing]];
    // Create a error text message
    PPMessage *errorTextMessage = [self makePPMessageWithText:@"GHI" withDirection:PPMessageDirectionOutgoing];
    errorTextMessage.status = PPMessageStatusError;
    [messages addObject:errorTextMessage];
    
    [messages addObject:[self makePPMessageWithImageUrl:@"http://images.wookmark.com/111098_nature-animals-wildlife-dogs-1920x1080-wallpaper_www.wall321.com_43.jpg"
                                        withImageWidth:634
                                        withImageHeight:356
                                          withDirection:PPMessageDirectionIncoming]];
    [messages addObject:[self makePPMessageWithImageUrl:@"http://lemanoosh.com/wp-content/uploads/d6374625065727.5634d1ec41b4c-500x888.jpg"
                                         withImageWidth:500
                                        withImageHeight:888
                                          withDirection:PPMessageDirectionOutgoing]];
    
    [messages addObject:[self makePPMessageWithFileName:@"AA.txt" withFileSize:123 withDirection:PPMessageDirectionIncoming]];
    [messages addObject:[self makePPMessageWithFileName:@"BB.zip" withFileSize:456 withDirection:PPMessageDirectionOutgoing]];
    
    return messages;
}

- (NSMutableArray*)getGroupMembers {
    NSMutableArray *groupMembers = [NSMutableArray array];
    
    [groupMembers addObject:[self makeUserWithName:@"User A"
                                          withIcon:@"http://hitmaxz.com/wp-content/uploads/2014/11/cute-baby-photo-4.jpg"]];
    [groupMembers addObject:[self makeUserWithName:@"User B"
                                          withIcon:@"http://hitmaxz.com/wp-content/uploads/2014/11/6f39d6a9102d92dd150479919e44b0e02.jpg"]];
    [groupMembers addObject:[self makeUserWithName:@"User C"
                                          withIcon:@"http://hitmaxz.com/wp-content/uploads/2014/11/f9c4dce2f807a99ca5841652290bb29e111.jpg"]];
    [groupMembers addObject:[self makeUserWithName:@"User D"
                                          withIcon:@"http://hitmaxz.com/wp-content/uploads/2014/11/1620680_481832495278399_1860213514_n1.jpg"]];
    [groupMembers addObject:[self makeUserWithName:@"User E"
                                          withIcon:@"http://hitmaxz.com/wp-content/uploads/2014/11/cute-girls-kids-baby-31.jpg"]];
    
    return groupMembers;
}

- (PPApp*)getApp {
    PPApp *app = [[PPApp alloc] initWithAppKey:@"779337ae-f17c-11e5-8957-02287b8c0ebf"
                                     appSecret:@"779339b6-f17c-11e5-8957-02287b8c0ebf"
                                          uuid:@"77933ab0-f17c-11e5-8957-02287b8c0ebf"];
    return app;
}

- (PPServiceUser*)getServiceUser {
    PPServiceUser *serviceUser = [[PPServiceUser alloc] initWithUuid:@"7168bdd0-392b-11e6-b4b8-02287b8c0ebf"];
    serviceUser.mobileDeviceUuid = @"71976842-392b-11e6-b4b8-02287b8c0ebf";
    return serviceUser;
}

#pragma mark - helpers

- (PPConversationItem*)makeConverseationItemWithName:(NSString*)conversationName
                             withConversationSummary:(NSString*)conversationSummary
                                withConversationIcon:(NSString*)conversationIcon {
    PPConversationItem *conversationItem = [[PPConversationItem alloc] init];
    conversationItem.conversationName = conversationName;
    conversationItem.uuid = PPRandomUUID();
    conversationItem.conversationIcon = conversationIcon;
    conversationItem.latestMessage = [self makePPMessageWithText:conversationSummary];
    conversationItem.updateTimestamp = PPCurrentTimestamp();
    return conversationItem;
}

- (PPMessage*)makePPMessageWithText:(NSString*)textContent {
    return [self makePPMessageWithText:textContent withDirection:PPMessageDirectionUnknown];
}

- (PPMessage*)makePPMessageWithText:(NSString*)textContent
                      withDirection:(PPMessageDirection)direction {
    PPMessage *textMessage = [[PPMessage alloc] init];
    textMessage.type = PPMessageTypeText;
    textMessage.body = textContent;
    textMessage.identifier = PPRandomUUID();
    textMessage.fromUser = [self getUserForMessageDirection:direction];
    textMessage.direction = direction;
    return textMessage;
}

- (PPMessage*)makePPMessageWithImageUrl:(NSString*)imageUrl
                         withImageWidth:(NSUInteger)imageWidth
                        withImageHeight:(NSUInteger)imageHeight
                          withDirection:(PPMessageDirection)direction {
    PPMessage *imageMessage = [[PPMessage alloc] init];
    imageMessage.identifier = PPRandomUUID();
    imageMessage.type = PPMessageTypeImage;
    
    PPMessageImageMediaPart *imageMediaPart = [[PPMessageImageMediaPart alloc] init];
    imageMediaPart.imageUrl = [NSURL URLWithString:imageUrl];
    imageMediaPart.imageSize = CGSizeMake(imageWidth, imageHeight);
    imageMediaPart.thumbUrl = [NSURL URLWithString:imageUrl];
    imageMediaPart.thumbImageSize = CGSizeMake(imageWidth, imageHeight);
    
    imageMessage.mediaPart = imageMediaPart;
    imageMessage.fromUser = [self getUserForMessageDirection:direction];
    imageMessage.direction = direction;
    
    return imageMessage;
}

- (PPMessage*)makePPMessageWithFileName:(NSString*)fileName
                           withFileSize:(NSUInteger)fileSize
                          withDirection:(PPMessageDirection)direction {
    PPMessage *fileMessage = [[PPMessage alloc] init];
    fileMessage.identifier = PPRandomUUID();
    fileMessage.type = PPMessageTypeFile;
    
    PPMessageFileMediaPart *fileMediaPart = [[PPMessageFileMediaPart alloc] init];
    fileMediaPart.fileName = fileName;
    fileMediaPart.fileSize = fileSize;
    
    fileMessage.mediaPart = fileMediaPart;
    fileMessage.fromUser = [self getUserForMessageDirection:direction];
    fileMessage.direction = direction;
    
    return fileMessage;
}

- (PPUser*)makeUserWithName:(NSString*)userName
                   withIcon:(NSString*)userIcon {
    PPUser *user = [[PPUser alloc] initWithUuid:PPRandomUUID()];
    user.userName = userName;
    user.userIcon = userIcon;
    return user;
}

- (PPUser*)makeIncomingUser {
    return [self makeUserWithName:@"User A"
                         withIcon:@"https://www.tm-town.com/assets/default_female600x600-3702af30bd630e7b0fa62af75cd2e67c.png"];
}

- (PPUser*)makeOutgoingUser {
    return [self makeUserWithName:@"User B"
                         withIcon:@"http://f9.topitme.com/9/68/6f/11875246993c56f689l.jpg"];
}

- (PPUser*)getUserForMessageDirection:(PPMessageDirection)direction {
    if (direction == PPMessageDirectionIncoming) {
        return [self makeIncomingUser];
    }
    
    return [self makeOutgoingUser];
}

@end
