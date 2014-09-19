//
// Created by Jorg on 11/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CLLocationManagerProxySpy.h"


@implementation CLLocationManagerProxySpy {
}

- (void)startUpdatingLocation {
    _nrCallsForStartUpdatingLocation++;
    [super startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    _nrCallsForStopUpdatingLocation++;
}


@end