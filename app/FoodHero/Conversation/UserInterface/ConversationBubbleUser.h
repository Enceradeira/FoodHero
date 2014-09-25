//
//  ConversationBubbleUser.h
//  FoodHero
//
//  Created by Jorg on 06/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubble.h"
#import "Statement.h"

@interface ConversationBubbleUser : ConversationBubble
- (id)initWithStatement:(Statement *)statement width:(CGFloat)width index:(NSUInteger)index doRenderSemanticID:(BOOL)ID;
@end
