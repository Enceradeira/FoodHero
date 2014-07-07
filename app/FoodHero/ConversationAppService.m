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
#import "DesignByContractException.h"
#import "Statement.h"
#import "Personas.h"
#import "ConversationRepository.h"

@implementation ConversationAppService
{
    NSMutableDictionary *_bubbles;
    NSMutableArray *_statements;
}

-(id)initWithService:(ConversationRepository*) conversationRepository
{
    self = [super init];
    if(self != nil)
    {
        _bubbles = [NSMutableDictionary new];
        _statements = [NSMutableArray new];
        [_statements addObject:[[Statement alloc] initWithText:@"Hi there. What kind of food would you like to eat?" semanticId:@"Greeting&OpeningQuestion" persona: Personas.foodHero]];
    }
    return self;
}

-(void) addStatement:(NSString*)statement
{
    [_statements addObject:[[Statement alloc] initWithText:statement semanticId:[NSString stringWithFormat:@"UserAnswer:%@",statement] persona:Personas.user]];
}

-(NSInteger)getStatementCount
{
    return [_statements count];
}

-(ConversationBubble*) getStatement:(NSInteger)index bubbleWidth:(CGFloat)bubbleWidth
{
    if (index > [_statements count]-1)
    {
        @throw [[DesignByContractException alloc] initWithReason:[NSString stringWithFormat:@"no conversation exists at index %ld", (long)index]];
    }
    NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long)index, (long)bubbleWidth];
    ConversationBubble *bubble = [_bubbles objectForKey: key];
    if(bubble == nil ){
        Statement *statement = (Statement*)_statements[index];
        
        if(statement.persona == Personas.foodHero)
        {
            bubble = [[ConversationBubbleFoodHero alloc] initWithText:statement.text semanticId:statement.semanticId viewWitdh:bubbleWidth];
        }
        else
        {
            bubble = [[ConversationBubbleUser alloc] initWithText:statement.text semanticId:statement.semanticId viewWitdh:bubbleWidth];
        }
    
        [_bubbles setObject:bubble forKey:key];
    }
    return bubble;
}
@end