//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FeedbackTableViewCell.h"
#import "AccessibilityHelper.h"


@implementation FeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setIsAccessibilityElement:YES];
}


- (void)setFeedback:(Feedback *)feedback {
    _feedback = feedback;
    [self UpdateView];
}

- (void)UpdateView {
    self.textLabel.text = _feedback.text;
    self.imageView.image = _feedback.image;

    self.accessibilityLabel = _feedback.text;
    self.accessibilityIdentifier = [NSString stringWithFormat:@"FeedbackEntry=%@", [AccessibilityHelper sanitizeForIdentifier:_feedback.text]];
}

@end