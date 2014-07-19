//
//  ConversationAppService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "ConversationAppService.h"
#import "ConversationBubbleFoodHero.h"
#import "ConversationBubbleUser.h"
#import "Personas.h"
#import "RACSignal.h"
#import "ConversationToken.h"

@implementation ConversationAppService {
    NSMutableDictionary *_bubbles;
    Conversation *_conversation;
}

- (id)initWithDependencies:(ConversationRepository *)conversationRepository {
    self = [super init];
    if (self != nil) {
        _bubbles = [NSMutableDictionary new];
        _conversation = conversationRepository.get;
    }
    return self;
}

- (void)addUserInput:(ConversationToken *)userInput {
    [_conversation addToken:userInput];
}

- (NSInteger)getStatementCount {
    return _conversation.getStatementCount;
}

- (ConversationBubble *)getStatement:(NSUInteger)index bubbleWidth:(CGFloat)bubbleWidth {

    NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long) index, (long) bubbleWidth];
    ConversationBubble *bubble = [_bubbles objectForKey:key];
    if (bubble == nil) {
        Statement *statement = [_conversation getStatement:index];

        if (statement.persona == Personas.foodHero) {
            bubble = [[ConversationBubbleFoodHero alloc] initWithStatement:statement width:bubbleWidth index:index inputAction:statement.inputAction];
        }
        else {
            bubble = [[ConversationBubbleUser alloc] initWithStatement:statement width:bubbleWidth index:index];
        }

        [_bubbles setObject:bubble forKey:key];
    }
    return bubble;
}

- (RACSignal *)statementIndexes {
   return _conversation.statementIndexes;
}
@end
