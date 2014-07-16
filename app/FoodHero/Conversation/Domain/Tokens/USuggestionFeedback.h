//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"


@interface USuggestionFeedback : ConversationToken
+ (USuggestionFeedback *)create:(NSString *)parameter;
@end