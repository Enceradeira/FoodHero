//
// Created by Jorg on 14/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IUITextVisualizer <NSObject>
- (void)setText:(NSString *)text;

- (void)setAccessibilityIdentifier:(NSString *)accessibilityIdentifier;

- (void)setTextColor:(UIColor *)textColor;
@end