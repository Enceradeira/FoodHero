//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Restaurant.h"
#import "FoodHero-Swift.h"


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

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToRestaurant:other];
}

- (BOOL)isEqualToRestaurant:(Restaurant *)restaurant {
    if (self == restaurant)
        return YES;
    if (restaurant == nil)
        return NO;
    if (![super isEqual:restaurant])
        return NO;
    if (self.vicinity != restaurant.vicinity && ![self.vicinity isEqualToString:restaurant.vicinity])
        return NO;
    if (self.name != restaurant.name && ![self.name isEqualToString:restaurant.name])
        return NO;
    if (self.nameUnique != restaurant.nameUnique && ![self.nameUnique isEqualToString:restaurant.nameUnique])
        return NO;
    if (self.address != restaurant.address && ![self.address isEqualToString:restaurant.address])
        return NO;
    if (self.addressComponents != restaurant.addressComponents && ![self.addressComponents isEqualToArray:restaurant.addressComponents])
        return NO;
    if (self.openingStatus != restaurant.openingStatus && ![self.openingStatus isEqualToString:restaurant.openingStatus])
        return NO;
    if (self.openingHoursToday != restaurant.openingHoursToday && ![self.openingHoursToday isEqualToString:restaurant.openingHoursToday])
        return NO;
    if (self.openingHours != restaurant.openingHours && ![self.openingHours isEqualToArray:restaurant.openingHours])
        return NO;
    if (self.phoneNumber != restaurant.phoneNumber && ![self.phoneNumber isEqualToString:restaurant.phoneNumber])
        return NO;
    if (self.urlForDisplaying != restaurant.urlForDisplaying && ![self.urlForDisplaying isEqualToString:restaurant.urlForDisplaying])
        return NO;
    if (self.url != restaurant.url && ![self.url isEqualToString:restaurant.url])
        return NO;
    if (self.types != restaurant.types && ![self.types isEqualToArray:restaurant.types])
        return NO;
    if (self.distance != restaurant.distance && ![self.distance isEqual:restaurant.distance])
        return NO;
    if (self.rating != restaurant.rating && ![self.rating isEqual:restaurant.rating])
        return NO;
    if (self.photos != restaurant.photos && ![self.photos isEqualToArray:restaurant.photos])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [super hash];
    hash = hash * 31u + [self.vicinity hash];
    hash = hash * 31u + [self.name hash];
    hash = hash * 31u + [self.nameUnique hash];
    hash = hash * 31u + [self.address hash];
    hash = hash * 31u + [self.addressComponents hash];
    hash = hash * 31u + [self.openingStatus hash];
    hash = hash * 31u + [self.openingHoursToday hash];
    hash = hash * 31u + [self.openingHours hash];
    hash = hash * 31u + [self.phoneNumber hash];
    hash = hash * 31u + [self.urlForDisplaying hash];
    hash = hash * 31u + [self.url hash];
    hash = hash * 31u + [self.types hash];
    hash = hash * 31u + [self.distance hash];
    hash = hash * 31u + [self.rating hash];
    hash = hash * 31u + [self.photos hash];
    return hash;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _vicinity = [coder decodeObjectForKey:@"_vicinity"];
        _name = [coder decodeObjectForKey:@"_name"];
        _nameUnique = [coder decodeObjectForKey:@"_nameUnique"];
        _address = [coder decodeObjectForKey:@"_address"];
        _addressComponents = [coder decodeObjectForKey:@"_addressComponents"];
        _openingStatus = [coder decodeObjectForKey:@"_openingStatus"];
        _openingHoursToday = [coder decodeObjectForKey:@"_openingHoursToday"];
        self.openingHours = [coder decodeObjectForKey:@"self.openingHours"];
        _phoneNumber = [coder decodeObjectForKey:@"_phoneNumber"];
        _urlForDisplaying = [coder decodeObjectForKey:@"_urlForDisplaying"];
        _url = [coder decodeObjectForKey:@"_url"];
        _types = [coder decodeObjectForKey:@"_types"];
        _photos = [coder decodeObjectForKey:@"_photos"];
        _distance = [coder decodeObjectForKey:@"_distance"];
        _rating = [coder decodeObjectForKey:@"_rating"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeObject:self.vicinity forKey:@"_vicinity"];
    [coder encodeObject:self.name forKey:@"_name"];
    [coder encodeObject:self.nameUnique forKey:@"_nameUnique"];
    [coder encodeObject:self.address forKey:@"_address"];
    [coder encodeObject:self.addressComponents forKey:@"_addressComponents"];
    [coder encodeObject:self.openingStatus forKey:@"_openingStatus"];
    [coder encodeObject:self.openingHoursToday forKey:@"_openingHoursToday"];
    [coder encodeObject:self.openingHours forKey:@"self.openingHours"];
    [coder encodeObject:self.phoneNumber forKey:@"_phoneNumber"];
    [coder encodeObject:self.urlForDisplaying forKey:@"_urlForDisplaying"];
    [coder encodeObject:self.url forKey:@"_url"];
    [coder encodeObject:self.types forKey:@"_types"];
    [coder encodeObject:self.photos forKey:@"_photos"];
    [coder encodeObject:self.distance forKey:@"_distance"];
    [coder encodeObject:self.rating forKey:@"_rating"];
}


@end