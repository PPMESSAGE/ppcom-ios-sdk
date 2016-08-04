//
//  PPMessageItemBaseView.m
//  PPMessage
//
//  Created by PPMessage on 2/6/16.
//  Copyright © 2016 PPMessage. All rights reserved.
//

#import "PPMessageItemBaseView.h"

#import "PPMessageImageMediaPart.h"
#import "PPMessageItemLeftTextView.h"
#import "PPMessageItemRightTextView.h"
#import "PPMessageItemLeftFileView.h"
#import "PPMessageItemRightFileView.h"
#import "PPMessageItemLeftImageView.h"
#import "PPMessageItemRightImageView.h"
#import "PPMessageItemLeftLargeTxtView.h"
#import "PPMessageItemRightLargeTxtView.h"
#import "PPMessageItemLeftUnknownView.h"
#import "PPMessageItemRightUnknownView.h"
#import "PPMessageItemLeftVoiceView.h"
#import "PPMessageItemRightVoiceView.h"

#import "PPMessageUtils.h"
#import "PPSDKUtils.h"
#import "PPLog.h"
#import "PPConstants.h"

#import "PPMessageItemBaseView+PPOnTappedMessageItemCell.h"

@interface PPMessageItemBaseView ()

@property UIFont *messageTextFont;
@property UILabel *messageTimestampLabel;

@end

@implementation PPMessageItemBaseView

CGFloat const PPMessageItemViewAvatarWidth = 42;
CGFloat const PPMessageItemViewNameLabelHeight = 24;
CGFloat const PPMessageItemViewTimestampHeight = 22;

+ (NSCache *)sharedSizeCache {
    static NSCache *sharedSizeCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSizeCache = [NSCache new];
    });
    return sharedSizeCache;
}

+ (NSCache *)sharedBodySizeCache {
    static NSCache *sharedBodySizeCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBodySizeCache = [NSCache new];
    });
    return sharedBodySizeCache;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageTextFont = [UIFont systemFontOfSize:17];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)presentMessage:(PPMessage *)message {
    self.message = message;
    if (message.showTimestamp) {
        self.messageTimestampLabel.text = PPFormatTimestampToHumanReadableStyle(message.timestamp, YES);
    }
}

- (BOOL)addTapGestureRecognizer {
    return NO;
}

- (void)onMessageItemTapped:(UITapGestureRecognizer*)gr {
    if (self.message) {
        [self pp_onTappedMessage:self.message];
    }
}

- (UIView*)messageContentView {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (UIView*)messageTimestampView {
    if (!self.messageTimestampLabel) {
        self.messageTimestampLabel = [UILabel new];
        self.messageTimestampLabel.backgroundColor = PPTransparentColor(0.2);
        self.messageTimestampLabel.layer.cornerRadius = 2.0f;
        self.messageTimestampLabel.clipsToBounds = YES;
        self.messageTimestampLabel.textColor = [UIColor whiteColor];
        self.messageTimestampLabel.font = [UIFont systemFontOfSize:12];
    }
    return self.messageTimestampLabel;
}

#pragma mark - Cell Behaviour

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *target = [self messageContentView];
    CGPoint p = [self convertPoint:point toView:target];
    if (CGRectContainsPoint(target.bounds, p)) {
        return [target hitTest:p withEvent:event];
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - Cell Size Calculations

+ (CGFloat)cellHeightForMessage:(PPMessage *)message inView:(UIView *)view {
    return [self cellSizeForMessage:message inView:view].height;
}

+ (CGSize)cellSizeForMessage:(PPMessage *)message inView:(UIView *)view
{
    // Check Cache
    CGSize cellBodySize = CGSizeZero;
    
    if ([[self sharedSizeCache] objectForKey:message.identifier]) {
        cellBodySize = [[[self sharedSizeCache] objectForKey:message.identifier] CGSizeValue];
    } else {
        // Calculate
        switch (message.type) {
            case PPMessageTypeText:
                switch (message.direction) {
                    case PPMessageDirectionIncoming:
                        cellBodySize = [PPMessageItemLeftTextView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionOutgoing:
                        cellBodySize = [PPMessageItemRightTextView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionUnknown:
                        break;
                }
                break;
                
            case PPMessageTypeImage:
                switch (message.direction) {
                    case PPMessageDirectionIncoming:
                        cellBodySize = [PPMessageItemLeftImageView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionOutgoing:
                        cellBodySize = [PPMessageItemRightImageView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionUnknown:
                        break;
                }
                break;
                
            case PPMessageTypeFile:
                switch (message.direction) {
                    case PPMessageDirectionIncoming:
                        cellBodySize = [PPMessageItemLeftFileView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionOutgoing:
                        cellBodySize = [PPMessageItemRightFileView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionUnknown:
                        break;
                }
                break;
                
            case PPMessageTypeTxt:
                switch (message.direction) {
                    case PPMessageDirectionIncoming:
                        cellBodySize = [PPMessageItemLeftLargeTxtView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionOutgoing:
                        cellBodySize = [PPMessageItemRightLargeTxtView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionUnknown:
                        break;
                }
                break;
                
            case PPMessageTypeAudio:
                switch (message.direction) {
                    case PPMessageDirectionIncoming:
                        cellBodySize = [PPMessageItemLeftVoiceView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionOutgoing:
                        cellBodySize = [PPMessageItemRightVoiceView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionUnknown:
                        break;
                }
                break;
                
            case PPMessageTypeUnknown:
                switch (message.direction) {
                    case PPMessageDirectionIncoming:
                        cellBodySize = [PPMessageItemLeftUnknownView cellBodySizeForMessage:message];
                        break;
                        
                    case PPMessageDirectionOutgoing:
                        cellBodySize = [PPMessageItemRightUnknownView cellBodySizeForMessage:message];
                        break;
                        
                    default:
                        break;
                }
                
            default:
                break;
        }
    }
    
    // Cache Size
    if (![[self sharedSizeCache] objectForKey:message.identifier]) {
        [[self sharedSizeCache] setObject:[NSValue valueWithCGSize:cellBodySize] forKey:message.identifier];
    }
    
    CGSize targetSize = CGSizeMake(cellBodySize.width, cellBodySize.height);
    
    targetSize.height += 42;
    targetSize.height += 8 + 5 * 2;
    
    if (message.showTimestamp) {
        targetSize.height += PPMessageItemViewTimestampHeight;
    }
    
    return targetSize;
}

+ (CGSize)cellBodySizeForMessage:(PPMessage *)message {
    return CGSizeZero;
}

+ (CGSize)cellBodySizeInCache:(PPMessage *)message {
    id obj = [[self sharedBodySizeCache] objectForKey:message.identifier];
    if (obj) {
        return [obj CGSizeValue];
    }
    return CGSizeZero;
}

+ (void)setCellBodySize:(CGSize)cellBodySize forMessage:(PPMessage *)message {
    if (![[self sharedBodySizeCache] objectForKey:message.identifier]) {
        [[self sharedBodySizeCache] setObject:[NSValue valueWithCGSize:cellBodySize] forKey:message.identifier];
    }
}

@end
