//
//  ConversationBubbleFoodHero.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubbleFoodHero.h"
#import "ConversationAction.h"

@implementation ConversationBubbleFoodHero
- (UIImage *)getImage {
    /*
     *  <------------76------------->
     *  |                   |       |
     *  |                   |       |
     *  |         x         |-- 11--|
     *  52                  |       |
     *  |                   |       |
     *  |----------------------------
     *  |           |               |
     *  |           8               |
     *  |           |               |
     *  |---------------------------¦
     */


    // image is 152x104 @2 or 76x52 @1 -> mask (defined @1) (32+1+(32+11))x(21+1+(22+8))
    return [[UIImage imageNamed:@"ConversationBubble-FoodHero.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 32, 22 + 8, 32 + 11)];
}

- (id)initWithText:(NSString *)text semanticId:(NSString *)semanticId width:(CGFloat)width index:(NSUInteger)index inputAction:(id <UAction>)inputAction {
    self = [super initWithText:text semanticId:semanticId width:width index:index];
    if (self) {
        _inputAction = inputAction;
    }
    return self;
}

- (NSString *)getBubbleViewConstraint {
    return @"H:|-5-[_bubbleView]";
}

- (CGFloat)textPaddingLeft {
    return 25;
}

- (CGFloat)textPaddingRight {
    return 20;
}

- (CGFloat)width:(CGFloat)viewWidth {
    return viewWidth * (CGFloat) 0.875;
}

- (CGFloat)paddingTopText {
    return 12;
}

- (CGFloat)paddingBottomText {
    return [self paddingTopText] + 2;
}

- (NSString *)cellId {
    return @"Bubble";
}

@end
