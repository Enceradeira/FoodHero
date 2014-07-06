//
//  ConversationBubbleFoodHero.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubbleFoodHero.h"

@implementation ConversationBubbleFoodHero
- (UIImage*)getImage
{
    /*
     *  <------------112------------>
     *  |                   |       |
     *  |                   |       |
     *  |         x         |-- 9---|
     *  92                  |       |
     *  |                   |       |
     *  |----------------------------
     *  |           |               |
     *  |           20              |
     *  |           |               |
     *  |---------------------------¦
     */
    
     
    // image is 224x184 @2 or 112x92 @1 -> mask (defined @1) (51+1+(51+9))x(35+1+(36+20))
    return [[UIImage imageNamed:@"ConversationBubble-FoodHero.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35,51,36+20,51+9) ];
}

- (NSString*) getBubbleViewConstraint
{
    return  @"H:|-5-[_bubbleView]";
}

- (CGFloat)textPaddingLeft
{
    return 30;
}

- (CGFloat)textPaddingRight
{
    return 30;
}

- (CGFloat) width: (CGFloat) viewWidth
{
    return viewWidth*0.875;
}

- (CGFloat) paddingForDropshadow
{
    return 20;
}

- (CGFloat) paddingTopAndBottomText
{
    return 10;
}

- (NSString*) cellId
{
    return @"FoodHeroBubble";
}

@end
