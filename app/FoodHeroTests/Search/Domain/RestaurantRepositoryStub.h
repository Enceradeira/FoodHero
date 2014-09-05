//
// Created by Jorg on 19/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRestaurantRepository.h"
#import "SearchException.h"


@interface RestaurantRepositoryStub : NSObject <IRestaurantRepository>
- (void)injectRestaurants:(NSArray *)restaurants;

- (void)injectException:(SearchException *)exception;
@end