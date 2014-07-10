//
// Created by Jorg on 09/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "IosLocationService.h"
#import <ReactiveCocoa.h>
#import "LocationDataManager.h"


@implementation IosLocationService {

    LocationDataManager *locationDataManager;
}


- (CLLocationCoordinate2D)getCurrentLocation {
    CLLocationCoordinate2D value;
    return value;
}

- (RACSignal *)currentLocation {
     if( locationDataManager == nil){
         locationDataManager = [LocationDataManager new];
     }
       
    return [locationDataManager.currentLocation doNext:^(id next){
        locationDataManager = nil;
    }];
}

@end