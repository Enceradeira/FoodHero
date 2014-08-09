//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#include "ViewDimensionHelper.h"
#import "DesignByContractException.h"

@implementation ViewDimensionHelper {
    UIView *_view;
}

- (int)height {
    CGSize rect = [UIScreen mainScreen].bounds.size;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //NSLog([NSString stringWithFormat:@"orient: %d",orientation]);
    switch (orientation) {
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            //NSLog([NSString stringWithFormat:@"height: %f",rect.height]);
            return (int) rect.height;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            //NSLog([NSString stringWithFormat:@"height: %f",rect.width]);
            return (int) rect.width;
        default:
            @throw [DesignByContractException createWithReason:@"Don't know how to handle that orientation"];
    }
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