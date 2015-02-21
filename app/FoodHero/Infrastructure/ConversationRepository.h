//
//  ConcersationService.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"

@interface ConversationRepository : NSObject

- (Conversation *)getForInput:(RACSignal *)input;

@end
