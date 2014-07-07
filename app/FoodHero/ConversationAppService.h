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

@interface ConversationAppService : NSObject

-(id)initWithService:(ConversationRepository*) conversationRepository;
-(ConversationBubble*) getStatement:(NSInteger)index bubbleWidth:(CGFloat)bubbleWidth;
-(void) addStatement:(NSString*)statement;
-(NSInteger)getStatementCount;

@end
