//
// Created by Jorg on 02/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RatingStarsImage.h"


@implementation RatingStarsImage {

}

+ (instancetype)create:(NSString *)name {
    return [[RatingStarsImage alloc] initWithName:name];
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _image = [UIImage imageNamed:name];
        _name = name;
    }
    return self;
}


@end