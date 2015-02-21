//
//  ConversationBubbleFoodHero.h
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubble.h"

@interface ConversationBubbleFoodHero : ConversationBubble

@property(nonatomic, readonly) NSString *state;

- (id)initWithStatement:(Statement *)statement width:(CGFloat)width index:(NSUInteger)index doRenderSemanticID:(BOOL)ID;
@end
