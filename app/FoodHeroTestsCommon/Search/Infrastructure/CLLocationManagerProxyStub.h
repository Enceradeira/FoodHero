//
// Created by Jorg on 11/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLLocationManagerProxy.h"


@interface CLLocationManagerProxyStub : NSObject <CLLocationManagerProxy>
- (void)injectLocations:(NSArray *)locations;

- (void)injectLatitude:(double)latitude longitude:(double)longitude;

- (void)injectAuthorizationStatus:(CLAuthorizationStatus)status;

- (void)moveLocation;
@end