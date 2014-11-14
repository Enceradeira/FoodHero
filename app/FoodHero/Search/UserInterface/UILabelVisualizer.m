//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UILabelVisualizer.h"


@implementation UILabelVisualizer {

    UILabel *_label;
}
+ (instancetype)create:(UILabel *)label {
    return [[UILabelVisualizer alloc] init:label];
}

- (id)init:(UILabel *)label {
    self = [super init];
    if (self) {
        _label = label;
    }
    return self;
}

- (void)setText:(NSString *)text {
    _label.text = text;
}

- (void)setAccessibilityIdentifier:(NSString *)accessibilityIdentifier {
    _label.accessibilityIdentifier = accessibilityIdentifier;
}

- (void)setTextColor:(UIColor *)textColor {
    _label.textColor = textColor;
}

@end