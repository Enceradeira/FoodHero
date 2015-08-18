//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"

@interface RestaurantBuilder : NSObject
- (Restaurant *)build;

- (RestaurantBuilder *)withPlaceId:(NSString *)placeId;

- (RestaurantBuilder *)withName:(NSString *)name;

- (RestaurantBuilder *)withNameUnique:(NSString *)nameUnique;

- (RestaurantBuilder *)withVicinity:(NSString *)vicinity;

- (RestaurantBuilder *)withLocation:(CLLocation *)location;

- (RestaurantBuilder *)withPriceLevel:(NSUInteger)priceLevel;

- (RestaurantBuilder *)withCuisineRelevance:(double)cuisineRelevance;

- (RestaurantBuilder *)withAddress:(NSString *)address;

- (RestaurantBuilder *)withOpeningStatus:(NSString *)openingStatus;

- (RestaurantBuilder *)withOpeningHoursToday:(NSString *)openingHours;

- (RestaurantBuilder *)withOpeningHours:(NSArray *)openingHours;

- (RestaurantBuilder *)withPhoneNumber:(NSString *)phoneNumber;

- (RestaurantBuilder *)withUrl:(NSString *)url;

- (RestaurantBuilder *)withUrlForDisplaying:(NSString *)url;

- (RestaurantBuilder *)withDistance:(RestaurantDistance *)distance;

- (RestaurantBuilder *)withReview:(RestaurantRating *)review;

- (RestaurantBuilder *)withPhotos:(NSArray *)photos;
@end