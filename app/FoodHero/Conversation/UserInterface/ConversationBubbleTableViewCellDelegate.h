//
// Created by Jorg on 03/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConversationBubbleTableViewCellDelegate <NSObject>
- (void)userDidTouchLinkInConversationBubbleWith:(Restaurant *)restaurant;
@end