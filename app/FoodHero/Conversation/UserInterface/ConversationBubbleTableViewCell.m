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
#import "TyphoonComponents.h"
#import "RestaurantDetailViewController.h"

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
    self.accessibilityLabel = bubble.textSource;
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
                    "body { margin: 0; padding: -1; line-height: 1.2; white-space: pre-wrap; }"
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
        NSString *semanticID = self.bubble.semanticId;
        if ([semanticID rangeOfString:@"FH:TellRestaurantLocation"].location != NSNotFound ||
                [semanticID rangeOfString:@"FH:CommentChoiceAndTellRestaurantLocation"].location != NSNotFound) {

            RestaurantMapViewController *controller = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantMapView"];
            [controller setRestaurant:self.bubble.suggestedRestaurant];
            [self.delegate userDidTouchLinkInConversationBubbleWith:controller];
        }
        else if ([semanticID rangeOfString:@"U:SuggestionFeedback=Like"].location != NSNotFound) {
            // Like
            SuggestionLikedController *controller = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"SuggestionLikedController"];
            [controller setRestaurant:self.bubble.suggestedRestaurant];
            [self.delegate userDidTouchLinkInConversationBubbleWith:controller];
        }
        else if (self.bubble.suggestedRestaurant != nil) {
            RestaurantDetailViewController *controller = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantDetail"];
            [controller setRestaurant:self.bubble.suggestedRestaurant];
            [self.delegate userDidTouchLinkInConversationBubbleWith:controller];
        }
        else {
            // Help link
            HelpViewController *controller = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"HelpController"];
            [self.delegate initalizeHelpController:controller];
            [self.delegate userDidTouchLinkInConversationBubbleWith:controller];
        }
    }
    return YES;
}

- (ConversationBubble *)bubble {
    return _bubble;
}
@end
