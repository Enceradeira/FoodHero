//
//  ConversationBubbleTableViewCell.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubbleTableViewCell.h"
#import "AccessibilityHelper.h"

@implementation ConversationBubbleTableViewCell {
    UIImageView *_bubbleView;
    ConversationBubble *_bubble;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBubble:(ConversationBubble *)bubble {
    if (bubble == _bubble) {
        return;
    }

    UIView *containerView = [self contentView];
    if (_bubbleView != nil) {
        [_bubbleView removeFromSuperview];
        _bubbleView = nil;
    }

    _bubble = bubble;

    UIImage *image = bubble.image;

    // Create View with image
    _bubbleView = [[UIImageView alloc] initWithImage:image];
    [_bubbleView setTranslatesAutoresizingMaskIntoConstraints:NO];

    // Draw border around bubble image and cell
    /*
    _bubbleView.layer.borderColor = [UIColor redColor].CGColor;
    _bubbleView.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 1.0f;
    */

    // Create TextView on top of ImageView
    UITextView *textView = [self createTextView:bubble];
    [_bubbleView addSubview:textView];

    [containerView addSubview:_bubbleView];

    NSArray *bubbleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[bubble getBubbleViewConstraint] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_bubbleView)];
    [containerView addConstraints:bubbleConstraints];


    // following makes element accessable from acceptance tests
    [self setIsAccessibilityElement:YES];
    self.accessibilityLabel = bubble.text;
    self.accessibilityIdentifier = [NSString stringWithFormat:@"%@-%@", @"ConversationBubble", [AccessibilityHelper sanitizeForIdentifier:bubble.semanticId]];

}

- (UITextView *)createTextView:(ConversationBubble *)bubble {
    UITextView *textView = [[UITextView alloc] initWithFrame:bubble.textRect];
    textView.text = bubble.text;
    // Draw border around bubble image and cell
    /*
    textView.layer.borderColor = [UIColor greenColor].CGColor;
    textView.layer.borderWidth = 1.0f;
    */
    textView.backgroundColor = [UIColor clearColor];
    textView.font = _bubble.font;

    // http://stackoverflow.com/questions/746670/how-to-lose-margin-padding-in-uitextview
    textView.textContainer.lineFragmentPadding = 0;
    textView.textContainerInset = UIEdgeInsetsZero;

    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    return textView;
}

- (ConversationBubble *)bubble {
    return _bubble;
}
@end
