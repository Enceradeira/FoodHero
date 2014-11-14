//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UITextViewVisualizer.h"


@implementation UITextViewVisualizer {

    UITextView *_textView;
}
+ (instancetype)create:(UITextView *)view {
    return [[UITextViewVisualizer alloc] init:view];
}

- (id)init:(UITextView *)label {
    self = [super init];
    if (self) {
        _textView = label;
    }
    return self;
}

- (void)setText:(NSString *)text {
    _textView.text = text;
}

- (void)setAccessibilityIdentifier:(NSString *)accessibilityIdentifier {
    _textView.accessibilityIdentifier = accessibilityIdentifier;
}

- (void)setTextColor:(UIColor *)textColor {
    _textView.textColor = textColor;
}
@end