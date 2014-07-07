//
//  ConversationAppService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationAppService.h"
#import "ConversationBubbleFoodHero.h"
#import "ConversationBubbleUser.h"
#import "Personas.h"

@implementation ConversationAppService {
    NSMutableDictionary *_bubbles;
    Conversation *_conversation;
}

- (id)initWithService:(ConversationRepository *)conversationRepository {
    self = [super init];
    if (self != nil) {
        _bubbles = [NSMutableDictionary new];
        _conversation = conversationRepository.get;
    }
    return self;
}

- (void)addStatement:(NSString *)statement {
    [_conversation addStatement:statement];
}

- (NSInteger)getStatementCount {
    return _conversation.getStatementCount;
}

- (ConversationBubble *)getStatement:(NSInteger)index bubbleWidth:(CGFloat)bubbleWidth {
    NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long) index, (long) bubbleWidth];
    ConversationBubble *bubble = [_bubbles objectForKey:key];
    if (bubble == nil) {
        Statement *statement = [_conversation getStatement:index];

        if (statement.persona == Personas.foodHero) {
            bubble = [[ConversationBubbleFoodHero alloc] initWithText:statement.text semanticId:statement.semanticId viewWitdh:bubbleWidth];
        }
        else {
            bubble = [[ConversationBubbleUser alloc] initWithText:statement.text semanticId:statement.semanticId viewWitdh:bubbleWidth];
        }

        [_bubbles setObject:bubble forKey:key];
    }
    return bubble;
}
@end
