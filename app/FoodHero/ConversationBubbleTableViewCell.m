//
//  ConversationBubbleTableViewCell.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubbleTableViewCell.h"

@implementation ConversationBubbleTableViewCell
{
    UIImageView *_bubbleView;
    ConversationBubble *_bubble;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setBubble:(ConversationBubble *)bubble
{
    _bubble = bubble;
    _bubbleView = [[UIImageView alloc] initWithImage: bubble.image];
    [_bubbleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // following makes element accessable from acceptance tests
    [self setIsAccessibilityElement:YES];
    self.accessibilityLabel = bubble.text;
    self.accessibilityIdentifier = [NSString stringWithFormat:@"%@-%@", @"ConversationBubble", bubble.semanticId];

     _bubbleView.layer.borderColor = [UIColor redColor].CGColor;
     _bubbleView.layer.borderWidth = 1.0f;
     self.layer.borderColor = [UIColor blueColor].CGColor;
     self.layer.borderWidth = 1.0f;
    
    UIView *containerView = [self contentView];
    [containerView addSubview:_bubbleView];
    
    NSArray *bubbleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[bubble getBubbleViewConstraint] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bubbleView)];
    [containerView addConstraints:bubbleConstraints];
}

- (ConversationBubble*)bubble
{
    return _bubble;
}
@end
