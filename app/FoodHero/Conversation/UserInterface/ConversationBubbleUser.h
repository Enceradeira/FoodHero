//
//  ConversationBubbleUser.h
//  FoodHero
//
//  Created by Jorg on 06/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubble.h"

@interface ConversationBubbleUser : ConversationBubble
- (id)initWithText:(NSString *)text semanticId:(NSString *)semanticId width:(CGFloat)width index:(NSUInteger)index;
@end
