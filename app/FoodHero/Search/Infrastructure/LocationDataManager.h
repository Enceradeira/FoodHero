//
// Created by Jorg on 10/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocationDataManager : NSObject<CLLocationManagerDelegate>
- (RACSignal *)currentLocation;
@end