//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantBuilder.h"
#import "OpeningHour.h"
#import "RestaurantRatingBuilder.h"
#import "PhotoBuilder.h"
#import "FoodHero-Swift.h"

@implementation RestaurantBuilder {

    NSString *_name;
    NSString *_vicinity;
    CLLocation *_location;
    NSUInteger _priceLevel;
    BOOL _priceLevelSet;
    double _cuisineRelevance;
    BOOL _cuisineRelevanceSet;
    NSString *_address;
    NSString *_url;
    NSString *_phoneNumber;
    NSString *_openingHoursToday;
    NSString *_openingStatus;
    NSString *_urlForDisplaying;
    NSArray *_addressComponents;
    NSArray *_openingHours;
    RestaurantDistance *_distance;
    RestaurantRating *_rating;
    NSArray *_photos;
}

- (Restaurant *)build {

    NSString *name = _name == nil ? @"Raj Palace" : _name;
    NSString *vicinity = _vicinity == nil ? @"18 Cathedral Street, Norwich" : _vicinity;
    NSString *address = _address == nil ? @"18 Cathedral Street\nNR1 1LX Norwich" : _address;
    NSArray *addressComponents = _addressComponents == nil ? @[@"18 Cathedral Street", @"Norwich", @"NR1 1LX", @"United Kingdom"] : _addressComponents;
    CLLocation *location = _location == nil ? [[CLLocation alloc] initWithLatitude:45.88879 longitude:1.55668] : _location;
    NSUInteger priceLevel = _priceLevelSet ? _priceLevel : 2;
    double cuisineRelevance = _cuisineRelevanceSet ? _cuisineRelevance : 0.8;
    NSString *openingStatus = _openingStatus == nil ? @"Open now" : _openingStatus;
    NSString *openingHoursToday = _openingHoursToday == nil ? @"12:00-3:00 pm\n5:30-11:15 pm" : _openingHoursToday;
    NSArray *openingHours = _openingHours == nil ? @[
            [OpeningHour create:@"Monday" hours:@"closed" isToday:NO],
            [OpeningHour create:@"Tuesday" hours:@"12:00-3:00 pm\n5:30-11:15 pm" isToday:NO],
            [OpeningHour create:@"Wednesday" hours:@"12:00-3:00 pm\n5:30-11:15 pm" isToday:NO],
            [OpeningHour create:@"Thursday" hours:@"12:00-3:00 pm\n5:30-11:15 pm" isToday:NO],
            [OpeningHour create:@"Friday" hours:@"12:00-3:00 pm\n5:30-11:15 pm" isToday:YES],
            [OpeningHour create:@"Saturday" hours:@"12:00-3:00 pm\n5:30-11:15 pm" isToday:NO],
            [OpeningHour create:@"Sunday" hours:@"12:00-3:00 pm\n5:30-11:15 pm" isToday:NO]] : _openingHours;
    NSString *phoneNumber = _phoneNumber == nil ? @"01603 777885" : _phoneNumber;
    NSString *url = _url == nil ? @"http://www.namaste.co.uk" : _url;
    NSString *urlForDisplaying = _urlForDisplaying == nil ? @"namaste.co.uk" : _urlForDisplaying;
    RestaurantDistance *restaurantDistance = _distance == nil ? [[RestaurantDistanceBuilder alloc]  build]: _distance;
    RestaurantRating *rating = _rating == nil ? [[RestaurantRatingBuilder alloc] build] : _rating;

    NSArray *photos = _photos == nil ? [self defaultPhotos] : _photos;
    return [Restaurant createWithName:name
                             vicinity:vicinity
                              address:address
                    addressComponents:addressComponents
                        openingStatus:openingStatus
                    openingHoursToday:openingHoursToday
                         openingHours:openingHours
                          phoneNumber:phoneNumber
                                  url:url
                     urlForDisplaying:urlForDisplaying
                                types:@[@"restaurant"]
                              placeId:[[NSUUID UUID] UUIDString]
                             location:location
                             distance:restaurantDistance
                           priceLevel:priceLevel
                     cuisineRelevance:cuisineRelevance
                               rating:rating
                               photos:photos];
}

- (NSArray *)defaultPhotos {
    return @[
            [[PhotoBuilder alloc] build],
            [[PhotoBuilder alloc] build]
    ];
}

- (RestaurantBuilder *)withName:(NSString *)name {
    _name = name;
    return self;
}

- (RestaurantBuilder *)withVicinity:(NSString *)vicinity {
    _vicinity = vicinity;
    return self;
}

- (RestaurantBuilder *)withLocation:(CLLocation *)location {
    _location = location;
    return self;
}

- (RestaurantBuilder *)withPriceLevel:(NSUInteger)priceLevel {
    _priceLevel = priceLevel;
    _priceLevelSet = YES;
    return self;
}

- (RestaurantBuilder *)withCuisineRelevance:(double)cuisineRelevance {
    _cuisineRelevance = cuisineRelevance;
    _cuisineRelevanceSet = YES;
    return self;
}

- (RestaurantBuilder *)withAddress:(NSString *)address {
    _address = address;
    return self;
}

- (RestaurantBuilder *)withAddressComponents:(NSArray *)components {
    _addressComponents = components;
    return self;
}


- (RestaurantBuilder *)withOpeningStatus:(NSString *)openingStatus {
    _openingStatus = openingStatus;
    return self;
}

- (RestaurantBuilder *)withOpeningHoursToday:(NSString *)openingHours {
    _openingHoursToday = openingHours;
    return self;
}

- (RestaurantBuilder *)withOpeningHours:(NSArray *)openingHours {
    _openingHours = openingHours;
    return self;
}

- (RestaurantBuilder *)withPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
    return self;
}

- (RestaurantBuilder *)withUrl:(NSString *)url {
    _url = url;
    return self;
}

- (RestaurantBuilder *)withUrlForDisplaying:(NSString *)url {
    _urlForDisplaying = url;
    return self;
}

- (RestaurantBuilder *)withDistance:(RestaurantDistance *)distance {
    _distance = distance;
    return self;
}

- (RestaurantBuilder *)withReview:(RestaurantRating *)review {
    _rating = review;
    return self;
}

- (RestaurantBuilder *)withPhotos:(NSArray *)photos {
    _photos = photos;
    return self;
}
@end