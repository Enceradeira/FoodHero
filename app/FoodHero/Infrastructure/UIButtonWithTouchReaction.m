//
// Created by Jorg on 24/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UIButtonWithTouchReaction.h"


@implementation UIButtonWithTouchReaction {
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   self.imageView.highlighted = YES;

   [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.imageView.highlighted = NO;

    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.imageView.highlighted = NO;

    [super touchesCancelled:touches withEvent:event];
}
@end