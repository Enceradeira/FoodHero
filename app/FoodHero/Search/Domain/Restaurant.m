//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Restaurant.h"


@implementation Restaurant
- (id)initWithName:(NSString *)name
          vicinity:(NSString *)vicinity
           address:(NSString *)address
     openingStatus:(NSString *)openingStatus
      openingHours:(NSString *)openingHours
       phoneNumber:(NSString *)phoneNumber
               url:(NSString *)url
             types:(NSArray *)types
           placeId:(NSString *)placeId
          location:(CLLocation *)location
        priceLevel:(NSUInteger)priceLevel
  cuisineRelevance:(double)cuisineRelevance {
    self = [super initWithPlaceId:placeId location:location priceLevel:priceLevel cuisineRelevance:cuisineRelevance];
    if (self != nil) {
        _name = name;
        _vicinity = vicinity;
        _types = types;
        _address = address;
        _openingStatus = openingStatus;
        _openingHours = openingHours;
        _phoneNumber = phoneNumber;
        _url = url;
    }
    return self;
}

+ (Restaurant *)createWithName:(NSString *)name
                      vicinity:(NSString *)vicinity
                       address:(NSString *)address
                 openingStatus:(NSString *)openingStatus
                  openingHours:(NSString *)openingHours
                   phoneNumber:(NSString *)phoneNumber
                           url:(NSString *)url
                         types:(NSArray *)types
                       placeId:(NSString *)placeId
                      location:(CLLocation *)location
                    priceLevel:(NSUInteger)priceLevel
              cuisineRelevance:(double)cuisineRelevance {
    return [[Restaurant alloc] initWithName:name
                                   vicinity:vicinity
                                    address:address
                              openingStatus:openingStatus
                               openingHours:openingHours
                                phoneNumber:phoneNumber
                                        url:url
                                      types:types
                                    placeId:placeId
                                   location:location
                                 priceLevel:priceLevel
                           cuisineRelevance:cuisineRelevance];
}
@end