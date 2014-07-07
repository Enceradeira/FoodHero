//
//  ConversationBubble.h
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversationBubble : NSObject

@property(readonly) CGFloat height;
@property(readonly) NSString *cellId;
@property(readonly) UIImage *image;
@property(readonly) NSString *text;
@property(readonly) NSString *semanticId;

- (id)initWithText:(NSString *)text semanticId:(NSString *)semanticId viewWitdh:(CGFloat)viewWidth;

- (NSString *)getBubbleViewConstraint;

@end
