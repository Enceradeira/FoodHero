//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Restaurant.h"


@implementation Restaurant
- (id)initWithName:(NSString *)name
        nameUnique:(NSString *)nameUnique
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
          distance:(RestaurantDistance *)distance
        priceLevel:(NSUInteger)priceLevel
  cuisineRelevance:(double)cuisineRelevance
            rating:(RestaurantRating *)rating
            photos:(NSArray *)photos {
    self = [super initWithPlaceId:placeId location:location priceLevel:priceLevel cuisineRelevance:cuisineRelevance];
    if (self != nil) {
        _name = name;
        _nameUnique = nameUnique;
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
        _photos = photos;
    }
    return self;
}

+ (Restaurant *)createWithName:(NSString *)name
                    nameUnique:(NSString *)nameUnique
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
                      distance:(RestaurantDistance *)distance
                    priceLevel:(NSUInteger)priceLevel
              cuisineRelevance:(double)cuisineRelevance
                        rating:(RestaurantRating *)rating
                        photos:(NSArray *)photos {
    return [[Restaurant alloc] initWithName:name
                                 nameUnique:nameUnique
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
                                     rating:rating
                                     photos:photos];
}

- (NSString *)readableId {
    return [NSString stringWithFormat:@"%@, %@", _name, _vicinity];
}

@end