//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Restaurant.h"
#import "RestaurantReview.h"


@implementation Restaurant
- (id)initWithName:(NSString *)name
          vicinity:(NSString *)vicinity
           address:(NSString *)address
 addressComponents:(NSArray *)addressComponents
     openingStatus:(NSString *)openingStatus
 openingHoursToday:(NSString *)openingHoursToday
      openingHours:(NSArray *)openingHours
       phoneNumber:(NSString *)phoneNumber
               url:(NSString *)url
  urlForDisplaying:(NSString *)urlForDisplaying
             types:(NSArray *)types
           placeId:(NSString *)placeId
          location:(CLLocation *)location
          distance:(double)distance
        priceLevel:(NSUInteger)priceLevel
  cuisineRelevance:(double)cuisineRelevance
            rating:(RestaurantRating *)rating {
    self = [super initWithPlaceId:placeId location:location priceLevel:priceLevel cuisineRelevance:cuisineRelevance];
    if (self != nil) {
        _name = name;
        _vicinity = vicinity;
        _types = types;
        _address = address;
        _openingStatus = openingStatus;
        _openingHoursToday = openingHoursToday;
        _openingHours = openingHours;
        _phoneNumber = phoneNumber;
        _url = url;
        _urlForDisplaying = urlForDisplaying;
        _addressComponents = addressComponents;
        _distance = distance;
        _rating = rating;
    }
    return self;
}

+ (Restaurant *)createWithName:(NSString *)name
                      vicinity:(NSString *)vicinity
                       address:(NSString *)address
             addressComponents:(NSArray *)addressComponents
                 openingStatus:(NSString *)openingStatus
             openingHoursToday:(NSString *)openingHoursToday
                  openingHours:(NSArray *)openingHours
                   phoneNumber:(NSString *)phoneNumber
                           url:(NSString *)url
              urlForDisplaying:(NSString *)urlForDisplaying
                         types:(NSArray *)types
                       placeId:(NSString *)placeId
                      location:(CLLocation *)location
                      distance:(double)distance
                    priceLevel:(NSUInteger)priceLevel
              cuisineRelevance:(double)cuisineRelevance
                        rating:(RestaurantRating *)rating {
    return [[Restaurant alloc] initWithName:name
                                   vicinity:vicinity
                                    address:address
                          addressComponents:addressComponents
                              openingStatus:openingStatus
                          openingHoursToday:openingHoursToday
                               openingHours:openingHours
                                phoneNumber:phoneNumber
                                        url:url
                           urlForDisplaying:urlForDisplaying
                                      types:types
                                    placeId:placeId
                                   location:location
                                   distance:distance
                                 priceLevel:priceLevel
                           cuisineRelevance:cuisineRelevance
                                     rating:rating];
}
@end