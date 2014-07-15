//
//  ConversationAppService.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationBubble.h"
#import "ConversationRepository.h"

@class RACSignal;
@class UserInput;

@interface ConversationAppService : NSObject

- (id)initWithDependencies:(ConversationRepository *)conversationRepository;

- (ConversationBubble *)getStatement:(NSUInteger)index bubbleWidth:(CGFloat)bubbleWidth;

- (RACSignal *)statementIndexes;

- (void)addUserInput:(UserInput *)userInput;

- (NSInteger)getStatementCount;

@end
