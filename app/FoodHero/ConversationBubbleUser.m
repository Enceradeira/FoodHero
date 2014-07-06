//
//  ConversationBubbleUser.m
//  FoodHero
//
//  Created by Jorg on 06/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubbleUser.h"

@implementation ConversationBubbleUser
- (UIImage*)getImage
{
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
    return [[UIImage imageNamed:@"ConversationBubble-User.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(21,32,22+8,32+11) ];
}

- (NSString*) getBubbleViewConstraint
{
    return  @"H:|-5-[_bubbleView]";
}

- (CGFloat)textPaddingLeft
{
    return 25;
}

- (CGFloat)textPaddingRight
{
    return 15;
}

- (CGFloat) width: (CGFloat) viewWidth
{
    return viewWidth*0.875;
}

- (CGFloat) paddingForDropshadow
{
    return 6;
}

- (CGFloat) paddingTopAndBottomText
{
    return 8;
}

- (NSString*) cellId
{
    return @"Bubble";
}
@end
