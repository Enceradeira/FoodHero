//
// Created by Jorg on 11/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLLocationManagerProxy.h"
#import "CLLocationManagerProxyStub.h"


@interface CLLocationManagerProxySpy : CLLocationManagerProxyStub
@property(nonatomic) NSUInteger nrCallsForStartUpdatingLocation;
@property(nonatomic) NSUInteger nrCallsForStopUpdatingLocation;
@end