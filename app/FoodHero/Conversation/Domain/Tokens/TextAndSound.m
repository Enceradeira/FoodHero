//
// Created by Jorg on 18/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TextAndSound.h"


@implementation TextAndSound {

}

- (instancetype)initWithText:(NSString *)text textAfterSong:(NSString *)textAfterSong sound:(Sound *)sound {
    self = [super init];
    if (self != nil) {
        _sound = sound;
        _text = text;
        _textAfterSound = textAfterSong;
    }
    return self;
}

+ (instancetype)create:(NSString *)text {
    return [[TextAndSound alloc] initWithText:text textAfterSong:nil sound:nil];
}

+ (instancetype)create:(NSString *)text sound:(Sound *)sound {
    return [[TextAndSound alloc] initWithText:text textAfterSong:nil sound:sound];
}

+ (instancetype)create:(NSString *)text textAfterSong:(NSString *)textAfterSong sound:(Sound *)sound {
    return [[TextAndSound alloc] initWithText:text textAfterSong:textAfterSong sound:sound];
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
    if (self.textAfterSound != sound.textAfterSound && ![self.textAfterSound isEqualToString:sound.textAfterSound])
        return NO;
    if (self.sound != sound.sound && ![self.sound isEqualToSound:sound.sound])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.text hash];
    hash = hash * 31u + [self.textAfterSound hash];
    hash = hash * 31u + [self.sound hash];
    return hash;
}


@end