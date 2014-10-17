//
// Created by Jorg on 14/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantBuilder.h"


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
    NSString *_openingHours;
    NSString *_openingStatus;
}

- (Restaurant *)build {

    NSString *name = _name == nil ? @"Raj Palace" : _name;
    NSString *vicinity = _vicinity == nil ? @"18 Cathedral Street, Norwich" : _vicinity;
    NSString *address = _address == nil ? @"18 Cathedral Street\nNR1 1LX Norwich" : _address;
    CLLocation *location = _location == nil ? [[CLLocation alloc] initWithLatitude:45.88879 longitude:1.55668] : _location;
    NSUInteger priceLevel = _priceLevelSet ? _priceLevel : 2;
    double cuisineRelevance = _cuisineRelevanceSet ? _cuisineRelevance : 0.8;
    NSString *openingStatus = _openingStatus == nil ? @"Open now" : _openingStatus;
    NSString *openingHours = _openingHours == nil ? @"12:00-3:00 pm\n5:30-11:15 pm" : _openingHours;
    NSString *phoneNumber = _phoneNumber == nil ? @"01603 777885" : _phoneNumber;
    NSString *url = _url == nil ? @"www.namaste.co.uk" : _url;
    return [Restaurant createWithName:name
                             vicinity:vicinity
                              address:address
                        openingStatus:openingStatus
                         openingHours:openingHours
                          phoneNumber:phoneNumber
                                  url:url
                                types:@[@"restaurant"]
                              placeId:[[NSUUID UUID] UUIDString]
                             location:location
                           priceLevel:priceLevel
                     cuisineRelevance:cuisineRelevance];
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

- (RestaurantBuilder *)withOpeningStatus:(NSString *)openingStatus {
    _openingStatus = openingStatus;
    return self;
}

- (RestaurantBuilder *)withOpeningHours:(NSString *)openingHours {
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
@end