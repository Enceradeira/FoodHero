//
// Created by Jorg on 10/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewController+ViewDimensionCalculator.h"
#import "DesignByContractException.h"


@implementation ConversationViewController (ViewDimensionCalculator)
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

- (NSInteger)userInputHeaderHeight {
    return 40;
}

- (NSInteger)userInputListHeight {
    NSInteger maxHeight = (NSInteger) (self.height / [self userInputListScreenProportion]);
    NSInteger optimalHeight = self.optimalUserInputListHeight;
    if (optimalHeight > maxHeight) {
        return maxHeight;
    }
    else {
        return optimalHeight;
    }
}

- (NSInteger)userInputListScreenProportion {
    return self.isPortraitOrientation ? 2 : 3;
}

- (NSInteger)bubbleViewHeight {
    return (NSInteger) self.height - self.userInputHeaderHeight - self.userInputListHeight;
}
@end