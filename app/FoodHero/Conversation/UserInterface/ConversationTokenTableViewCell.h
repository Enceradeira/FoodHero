//
// Created by Jorg on 10/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"


@interface ConversationTokenTableViewCell : UITableViewCell
@property(nonatomic, readonly) ConversationToken *token;

- (void)setToken:(ConversationToken *)token accessibilityId:(NSString *)accessibilityId;
@end