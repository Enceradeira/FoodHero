//
//  ConversationBubbleTableViewCell.m
//  FoodHero
//
//  Created by Jorg on 04/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationBubbleTableViewCell.h"
#import "AccessibilityHelper.h"
#import "FoodHeroColors.h"

@interface ConversationBubbleTableViewCell () <UIWebViewDelegate>
@end

@implementation ConversationBubbleTableViewCell {
    UIImageView *_bubbleView;
    ConversationBubble *_bubble;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
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
    _bubbleView.userInteractionEnabled = YES;
    [_bubbleView setTranslatesAutoresizingMaskIntoConstraints:NO];

    // Draw border around bubble image and cell
    /*
    _bubbleView.layer.borderColor = [UIColor redColor].CGColor;
    _bubbleView.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.layer.borderWidth = 1.0f;
    */

    // Create TextView on top of ImageView
    UIView *textView = [self createTextView:bubble];
    [_bubbleView addSubview:textView];

    [containerView addSubview:_bubbleView];

    NSArray *bubbleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[bubble getBubbleViewConstraint] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_bubbleView)];
    [containerView addConstraints:bubbleConstraints];


    // following makes element accessable from acceptance tests
    [self setIsAccessibilityElement:YES];
    self.accessibilityLabel = bubble.text;
    self.accessibilityIdentifier = [NSString stringWithFormat:@"%@-%@", @"ConversationBubble", [AccessibilityHelper sanitizeForIdentifier:bubble.semanticId]];

}

- (UIView *)createTextView:(ConversationBubble *)bubble {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:bubble.textRect];

    UIFont *font = bubble.font;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [[FoodHeroColors actionColor] getRed:&red green:&green blue:&blue alpha:&alpha];


    NSString *htmlContentString = [NSString stringWithFormat:
            @"<html>"
                    "<style type=\"text/css\">"
                    "body { background-color:transparent; font-family:Helvetica Neue; font-size:%f;}"
                    "body { margin: 0; padding: 0; line-height: 1.2; white-space: pre-wrap; }"
                    "a:link, a:visited { color: rgb(%i,%i,%i); }"
                    "</style>"
                    "<body>"
                    "%@"
                    "</body></html>", font.pointSize, (int) (red * ColorDivisor), (int) (green * ColorDivisor), (int) (blue * ColorDivisor), bubble.textAsHtml];


    [webView loadHTMLString:htmlContentString baseURL:nil];
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.userInteractionEnabled = YES;
    webView.dataDetectorTypes = UIDataDetectorTypeLink;
    webView.scrollView.scrollEnabled = NO;
    [webView setTranslatesAutoresizingMaskIntoConstraints:NO];

    // draw border around WebView
    /*
    webView.layer.borderColor = [UIColor greenColor].CGColor;
    webView.layer.borderWidth = 1.0f;
    */

    return webView;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked && self.delegate) {
        [self.delegate userDidTouchLinkInConversationBubbleWith:self.bubble.suggestedRestaurant];
    }
    return YES;
}


- (UIView *)createTextView2:(ConversationBubble *)bubble {
    UITextView *textView = [[UITextView alloc] initWithFrame:bubble.textRect];
    // textView.text = bubble.text;

    NSDictionary *attributes = @{NSUnderlineStyleAttributeName : @(YES)};


    textView.attributedText = [[NSAttributedString alloc] initWithString:bubble.text attributes:attributes];
    // Draw border around bubble image and cell

    textView.layer.borderColor = [UIColor greenColor].CGColor;
    textView.layer.borderWidth = 1.0f;

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
