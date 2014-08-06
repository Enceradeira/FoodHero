//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//


@interface ViewDimensionHelper : NSObject
- (int)userInputHeaderHeight;

- (int)userInputListHeight;

- (int)bubbleViewHeight;

+ (instancetype)create:(UIView *)view;
@end
