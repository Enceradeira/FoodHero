//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "PhotoBuilder.h"
#import "IPhoto.h"


@interface PhotoStub : NSObject <IPhoto>
- (id)init:(UIImage *)image;
@end

@implementation PhotoStub {
    UIImage *_image;
}

- (id)init:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
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

+ (instancetype)create:(UIImage *)image {
    return [[PhotoStub alloc] init:image];
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