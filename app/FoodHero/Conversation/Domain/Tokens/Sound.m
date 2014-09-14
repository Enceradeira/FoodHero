//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Sound.h"


@implementation Sound {

}
+ (instancetype)create:(NSString *)file type:(NSString *)type length:(float)length {
    return [[Sound alloc] init:file type:type length:length];
}

- (instancetype)init:(NSString *)file type:(NSString *)type length:(float)length {
    self = [super init];
    if (self != nil) {
        _type = type;
        _length = length;
        _file = file;
    }
    return self;
}

@end