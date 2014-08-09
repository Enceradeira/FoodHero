//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#include "ViewDimensionHelper.h"
#import "DesignByContractException.h"
#import "ConversationViewController.h"

@implementation ViewDimensionHelper {
    ConversationViewController *_controller;
}

- (CGFloat)height {
    CGSize rect = [UIScreen mainScreen].bounds.size;
    if (self.isPortraitOrientation) {
        return rect.height;
    }
    else {
        return rect.width;
    }
}

- (BOOL)isPortraitOrientation {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //NSLog([NSString stringWithFormat:@"orient: %d",orientation]);
    switch (orientation) {
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            //NSLog([NSString stringWithFormat:@"height: %f",rect.height]);
            return YES;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            //NSLog([NSString stringWithFormat:@"height: %f",rect.width]);
            return NO;
        default:
            @throw [DesignByContractException createWithReason:@"Don't know how to handle that orientation"];
    }
}

- (id)initWithView:(ConversationViewController *)controller {
    self = [super init];
    if (self != nil) {
        _controller = controller;
    }
    return self;
}

- (int)userInputHeaderHeight {
    return 40;
}

- (int)userInputListHeight {
    int maxHeight = (int) (self.height / [self userInputListScreenProportion]);
    int optimalHeight = _controller.optimalUserInputListHeight;
    if (optimalHeight > maxHeight) {
        return maxHeight;
    }
    else {
        return optimalHeight;
    }
}

- (int)userInputListScreenProportion {
    return self.isPortraitOrientation ? 2 : 3;
}

- (int)bubbleViewHeight {
    return (int) self.height - self.userInputHeaderHeight - self.userInputListHeight;
}

+ (instancetype)create:(ConversationViewController *)controller {
    return [[ViewDimensionHelper alloc] initWithView:controller];
}


@end