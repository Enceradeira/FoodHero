//
//  ConversationBubble.h
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversationBubble : NSObject

@property(nonatomic, readonly) CGFloat height;
@property(nonatomic, readonly) NSString *cellId;
@property(nonatomic, readonly) UIImage *image;
@property(nonatomic, readonly) NSString *text;
@property(nonatomic, readonly) NSString *semanticId;

- (CGFloat)textPaddingLeft;

- (UIImage *)getImage;

- (CGFloat)textPaddingRight;

- (CGFloat)width:(CGFloat)viewWidth;

- (CGFloat)paddingBottomText;

- (CGFloat)paddingTopText;

- (id)initWithText:(NSString *)text semanticId:(NSString *)semanticId viewWitdh:(CGFloat)viewWidth;

- (NSString *)getBubbleViewConstraint;

@end
