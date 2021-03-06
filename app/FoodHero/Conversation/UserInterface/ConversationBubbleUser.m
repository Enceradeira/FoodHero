//
//  ConversationBubbleUser.m
//  FoodHero
//
//  Created by Jorg on 06/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubbleUser.h"

@implementation ConversationBubbleUser

- (id)initWithStatement:(Statement *)statement width:(CGFloat)width index:(NSUInteger)index doRenderSemanticID:(BOOL)doRenderSemanticID {
    self = [super initWithStatement:statement width:width index:index doRenderSemanticID:doRenderSemanticID];
    return self;
}

- (UIImage *)getImage {
    // the same mask as in ConversationBubbleFoodHero can be used since they have same vertical structure
    return [[UIImage imageNamed:@"ConversationBubble-User.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 32, 22 + 8, 32 + 11)];
}

- (NSString *)getBubbleViewConstraint {
    return @"H:[_bubbleView]-5-|";
}

- (CGFloat)textPaddingLeft {
    return 18;
}

- (CGFloat)textPaddingRight {
    return 30;
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
