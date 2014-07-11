//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "LocationServiceStub.h"
#import "RACSignal.h"


@implementation LocationServiceStub {

    CLLocationCoordinate2D _location;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        _location.latitude = 52.6259; // The Maids Head Hotel, Tombland, Norwich
        _location.longitude = 1.299484;
    }
    return self;
}

- (void)injectLocation:(CLLocationCoordinate2D)location {
    _location = location;
}

- (RACSignal *)currentLocation {

    //return [RACSignal empty];
    NSValue *value = [NSValue valueWithBytes:&_location objCType:@encode(CLLocationCoordinate2D)];
    return [RACSignal return:value];
}


@end