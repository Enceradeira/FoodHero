//
//  Conversation.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Conversation.h"
#import "Personas.h"
#import "DesignByContractException.h"

@implementation Conversation
{
        NSMutableArray *_statements;
}

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        _statements = [NSMutableArray new];
        [_statements addObject:[[Statement alloc] initWithText:@"Hi there. What kind of food would you like to eat?" semanticId:@"Greeting&OpeningQuestion" persona: Personas.foodHero]];
    }
    return self;
}

-(Statement*)getStatement:(NSInteger)index
{
    if (index > [_statements count]-1)
    {
        @throw [[DesignByContractException alloc] initWithReason:[NSString stringWithFormat:@"no conversation exists at index %ld", (long)index]];
    }

    return _statements[index];
}

-(void) addStatement:(NSString*)statement
{
    [_statements addObject:[[Statement alloc] initWithText:statement semanticId:[NSString stringWithFormat:@"UserAnswer:%@",statement] persona:Personas.user]];
}

-(NSInteger)getStatementCount
{
    return _statements.count;
}

@end
