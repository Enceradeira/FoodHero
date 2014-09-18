//
// Created by Jorg on 18/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TextAndSound.h"


@implementation TextAndSound {

}

- (instancetype)initWithText:(NSString *)text sound:(Sound *)sound {
    self = [super init];
    if (self != nil) {
        _sound = sound;
        _text = text;
    }
    return self;
}

+ (instancetype)create:(NSString *)text {
    return [[TextAndSound alloc] initWithText:text sound:nil];
}

+ (instancetype)create:(NSString *)text sound:(Sound *)sound {
    return [[TextAndSound alloc] initWithText:text sound:sound];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToSound:other];
}

- (BOOL)isEqualToSound:(TextAndSound *)sound {
    if (self == sound)
        return YES;
    if (sound == nil)
        return NO;
    if (self.text != sound.text && ![self.text isEqualToString:sound.text])
        return NO;
    if (self.sound != sound.sound && ![self.sound isEqual:sound.sound])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.text hash];
    hash = hash * 31u + [self.sound hash];
    return hash;
}


@end