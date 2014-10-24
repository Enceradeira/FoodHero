//
// Created by Jorg on 24/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UILabelWithTouchReaction.h"


@implementation UILabelWithTouchReaction
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.alpha = 0.2;

    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.alpha = 1;

    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.alpha = 1;

    [super touchesEnded:touches withEvent:event];
}
@end