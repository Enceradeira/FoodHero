//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "PhotoBuilder.h"
#import "IPhoto.h"


@interface PhotoStub : NSObject <IPhoto>
- (id)init:(NSString *)url;
@end

@implementation PhotoStub {
    NSString *_url;
}

- (id)init:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

- (NSString *)url {
    return _url;
}

+ (instancetype)create:(NSString *)url {
    return [[PhotoStub alloc] init:url];
}

@end

@implementation PhotoBuilder {

    NSString *_url;
}

- (id <IPhoto>)build {
    return [PhotoStub create:_url == nil ? @"http://rack.3.mshcdn.com/media/ZgkyMDEzLzA3LzE4L2I1L0dvb2dsZU1hcHNSLmQ0OWY4LmpwZwpwCXRodW1iCTk1MHg1MzQjCmUJanBn/9e01169a/119/GoogleMapsRestaurant.jpg" : _url];
}

- (instancetype)withUrl:(NSString *)url {
    _url = url;
    return self;
}


@end