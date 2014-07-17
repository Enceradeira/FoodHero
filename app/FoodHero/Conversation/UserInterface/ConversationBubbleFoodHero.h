//
//  ConversationBubbleFoodHero.h
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubble.h"
#import "UAction.h"

@protocol ConversationAction;

@interface ConversationBubbleFoodHero : ConversationBubble

@property(nonatomic, readonly) id <UAction> inputAction;

- (id)initWithText:(NSString *)text semanticId:(NSString *)semanticId width:(CGFloat)width index:(NSUInteger)index inputAction:(id <UAction>)inputAction;
@end
