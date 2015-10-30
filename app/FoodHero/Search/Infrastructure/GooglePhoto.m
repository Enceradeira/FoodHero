//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "GooglePhoto.h"
#import "GoogleDefinitions.h"
#import "FoodHero-Swift.h"

@implementation GooglePhoto {
    NSString *_photoReference;
    NSUInteger _originalHeight;
    NSUInteger _originalWidth;
    UIImage *_loadedImage;
    BOOL _isEagerlyLoaded;
}
- (NSString *)url {
    return [NSString stringWithFormat:@"%@/maps/api/place/photo?photoreference=%@&maxheight=%li&maxwidth=%li&key=%@", Configuration.urlGoogleMapsApi, _photoReference, (long)_originalHeight, (long)_originalWidth, Configuration.apiKeyGoogle];
}

- (BOOL)isEagerlyLoaded {
    return _isEagerlyLoaded;
}

- (void)preFetchImage {
    [self image];
}


- (id)initWithReference:(NSString *)reference height:(NSUInteger)height width:(NSUInteger)width loadEagerly:(BOOL)loadEagerly {
    self = [super init];
    if (self != nil) {
        _photoReference = reference;
        _originalHeight = height;
        _originalWidth = width;
        if (loadEagerly) {
            [self preFetchImage];
            _isEagerlyLoaded = loadEagerly;
        }
    }
    return self;
}

+ (instancetype)create:(NSString *)photoReference height:(NSUInteger)height width:(NSUInteger)width loadEagerly:(BOOL)loadEagerly {
    return [[GooglePhoto alloc] initWithReference:photoReference height:height width:width loadEagerly:loadEagerly];
}

- (RACSignal *)image {
    return [RACSignal startEagerlyWithScheduler:[RACScheduler scheduler] block:^(id <RACSubscriber> subscriber) {
        if (!_loadedImage) {
            NSURL *url = [NSURL URLWithString:[self url]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            _loadedImage = [[UIImage alloc] initWithData:data];
        }
        if (_loadedImage) {
            [subscriber sendNext:_loadedImage];
            [subscriber sendCompleted];
        }
        else {
            [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:nil]];
        }
    }];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _photoReference = [coder decodeObjectForKey:@"_photoReference"];
        _originalHeight = [coder decodeInt64ForKey:@"_originalHeight"];
        _originalWidth = [coder decodeInt64ForKey:@"_originalWidth"];
        _loadedImage = [coder decodeObjectForKey:@"_loadedImage"];
        _isEagerlyLoaded = [coder decodeBoolForKey:@"_isEagerlyLoaded"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_photoReference forKey:@"_photoReference"];
    [coder encodeInt64:_originalHeight forKey:@"_originalHeight"];
    [coder encodeInt64:_originalWidth forKey:@"_originalWidth"];
    [coder encodeObject:_loadedImage forKey:@"_loadedImage"];
    [coder encodeBool:_isEagerlyLoaded forKey:@"_isEagerlyLoaded"];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToPhoto:other];
}

- (BOOL)isEqualToPhoto:(GooglePhoto *)photo {
    if (self == photo)
        return YES;
    if (photo == nil)
        return NO;
    if (_photoReference != photo->_photoReference && ![_photoReference isEqualToString:photo->_photoReference])
        return NO;
    if (_originalHeight != photo->_originalHeight)
        return NO;
    if (_originalWidth != photo->_originalWidth)
        return NO;
    // Same image decoded is not equal even thought containing same picture. Comparing only _photoReference is ok.
    /*
    if (_loadedImage != photo->_loadedImage && ![_loadedImage isEqual:photo->_loadedImage])
        return NO;*/
    if (_isEagerlyLoaded != photo->_isEagerlyLoaded)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [_photoReference hash];
    hash = hash * 31u + _originalHeight;
    hash = hash * 31u + _originalWidth;
    hash = hash * 31u + [_loadedImage hash];
    hash = hash * 31u + _isEagerlyLoaded;
    return hash;
}


@end
