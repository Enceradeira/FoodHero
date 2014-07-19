//
//  ConversationBubble.h
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Statement.h"

@interface ConversationBubble : NSObject

@property(nonatomic, readonly) CGFloat height;
@property(nonatomic, readonly) NSString *cellId;
@property(nonatomic, readonly) UIImage *image;
@property(nonatomic, readonly) NSUInteger index;

- (NSString *)semanticId;

- (NSString *)text;

- (id)initWithStatement:(Statement *)statement width:(CGFloat)viewWidth index:(NSUInteger)index;

- (CGFloat)textPaddingLeft;

- (UIImage *)getImage;

- (CGFloat)textPaddingRight;

- (CGFloat)width:(CGFloat)viewWidth;

- (CGFloat)paddingBottomText;

- (CGFloat)paddingTopText;

- (NSString *)getBubbleViewConstraint;

- (Restaurant *)suggestedRestaurant;
@end
