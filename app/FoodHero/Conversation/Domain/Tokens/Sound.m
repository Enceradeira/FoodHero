//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Sound.h"
#import "PlaySoundDelegate.h"


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

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToSound:other];
}

- (BOOL)isEqualToSound:(Sound *)sound {
    if (self == sound)
        return YES;
    if (sound == nil)
        return NO;
    if (self.file != sound.file && ![self.file isEqualToString:sound.file])
        return NO;
    if (self.type != sound.type && ![self.type isEqualToString:sound.type])
        return NO;
    if (self.length != sound.length)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.file hash];
    hash = hash * 31u + [self.type hash];
    hash = hash * 31u + [[NSNumber numberWithFloat:self.length] hash];
    return hash;
}


@end