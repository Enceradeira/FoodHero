//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "RestaurantSearchParams.h"

@protocol RestaurantSearchService <NSObject>
- (NSArray *)find:(RestaurantSearchParams *)parameter;
@end