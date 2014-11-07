//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "GooglePhoto.h"
#import "GoogleDefinitions.h"

@implementation GooglePhoto {
    NSString *_photoReference;
    NSUInteger _originalHeight;
    NSUInteger _originalWidth;
    UIImage *_loadedImage;
    BOOL _isEagerlyLoaded;
}
- (NSString *)url {
    return [NSString stringWithFormat:@"%@/maps/api/place/photo?photoreference=%@&maxheight=%u&maxwidth=%u&key=%@", GOOGLE_BASE_ADDRESS, _photoReference, _originalHeight, _originalWidth, GOOGLE_API_KEY];
}

- (BOOL)isEagerlyLoaded {
    return _isEagerlyLoaded;
}


- (id)init:(NSString *)reference height:(NSUInteger)height width:(NSUInteger)width loadEagerly:(BOOL)loadEagerly {
    self = [super init];
    if (self != nil) {
        _photoReference = reference;
        _originalHeight = height;
        _originalWidth = width;
        if (loadEagerly) {
            RACSignal *dummySignal = [self image];
            _isEagerlyLoaded = loadEagerly;
        }
    }
    return self;
}

+ (instancetype)create:(NSString *)photoReference height:(NSUInteger)height width:(NSUInteger)width loadEagerly:(BOOL)loadEagerly {
    return [[GooglePhoto alloc] init:photoReference height:height width:width loadEagerly:loadEagerly];
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
@end
