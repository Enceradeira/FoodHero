//
//  ConversationBubbleFoodHero.h
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubble.h"
#import "IUAction.h"

@interface ConversationBubbleFoodHero : ConversationBubble

@property(nonatomic, readonly) id <IUAction> inputAction;

- (id)initWithStatement:(Statement *)statement width:(CGFloat)width index:(NSUInteger)index inputAction:(id <IUAction>)inputAction doRenderSemanticID:(BOOL)ID;
@end
