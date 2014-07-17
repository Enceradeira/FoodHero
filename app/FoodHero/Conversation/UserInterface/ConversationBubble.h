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
@property(nonatomic, readonly) NSUInteger index;

- (id)initWithText:(NSString *)text semanticId:(NSString *)semanticId width:(CGFloat)viewWidth index:(NSUInteger)index;

- (CGFloat)textPaddingLeft;

- (UIImage *)getImage;

- (CGFloat)textPaddingRight;

- (CGFloat)width:(CGFloat)viewWidth;

- (CGFloat)paddingBottomText;

- (CGFloat)paddingTopText;

- (NSString *)getBubbleViewConstraint;

@end
