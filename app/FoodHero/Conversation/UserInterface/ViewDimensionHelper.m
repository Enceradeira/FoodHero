//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#include "ViewDimensionHelper.h"

@implementation ViewDimensionHelper {
    UIView *_view;
}

- (int)height {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return (int) [_view convertRect:screenBounds fromView:nil].size.height;
}

- (id)initWithView:(UIView *)view {
    self = [super init];
    if (self != nil) {
        _view = view;
    }
    return self;
}

- (int)userInputHeaderHeight {
    return 60;
}

- (int)userInputListHeight {
    return self.height / 2;
}

- (int)bubbleViewHeight {
    return self.height - self.userInputHeaderHeight - self.userInputListHeight;
}

+ (instancetype)create:(UIView *)view {
    return [[ViewDimensionHelper alloc] initWithView:view];
}


@end