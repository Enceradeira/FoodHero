//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Feedback.h"


@implementation Feedback {
    UIImage *_image;
}
+ (instancetype)create:(NSString *)text image:(UIImage *)image {
    return [[Feedback alloc] initWithText:text image:image];
}

- (id)initWithText:(NSString *)text image:(UIImage *)image {
    self = [super init];
    if (self != nil) {
        _text = text;
        _image = image;
    }
    return self;
}

- (UIImage *)image {
    return _image;
}
@end