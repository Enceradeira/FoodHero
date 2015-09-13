//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "PhotoBuilder.h"
#import "IPhoto.h"


@interface PhotoStub : NSObject <IPhoto, NSCoding>
- (id)initWithReference:(NSString *)photoReference image:(UIImage *)image;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToStub:(PhotoStub *)stub;

- (NSUInteger)hash;

@end

@implementation PhotoStub {
    UIImage *_image;
    NSString *_photoReference;
}

- (id)initWithReference:(NSString *)photoReference image:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
        _photoReference = photoReference;
    }
    return self;
}

- (RACSignal *)image {
    return [RACSignal startEagerlyWithScheduler:[RACScheduler immediateScheduler] block:^(id <RACSubscriber> subscriber) {
        if (_image) {
            [subscriber sendNext:_image];
            [subscriber sendCompleted];
        }
        else {
            [subscriber sendError:nil];
        }
    }];
}

- (BOOL)isEagerlyLoaded {
    return NO;
}

- (void)preFetchImage {

}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _image = [coder decodeObjectForKey:@"_image"];
        _photoReference = [coder decodeObjectForKey:@"_photoReference"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_image forKey:@"_image"];
    [coder encodeObject:_photoReference forKey:@"_photoReference"];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToStub:other];
}

- (BOOL)isEqualToStub:(PhotoStub *)stub {
    if (self == stub)
        return YES;
    if (stub == nil)
        return NO;

    // decoded image is never equal to same original image
    /*
    if (_image != stub->_image && ![_image isEqual:stub->_image])
        return NO;*/
    if (_photoReference != stub->_photoReference && ![_photoReference isEqualToString:stub->_photoReference])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [_image hash];
    hash = hash * 31u + [_photoReference hash];
    return hash;
}


+ (instancetype)create:(UIImage *)image {
    return [[PhotoStub alloc] initWithReference:@"4488813-ABDD" image:image];
}

@end

@implementation PhotoBuilder {

    UIImage *_image;
}

- (id <IPhoto>)build {
    return [PhotoStub create:_image == nil ? [UIImage new] : _image];
}

- (instancetype)withImage:(UIImage *)image {
    _image = image;
    return self;
}


@end