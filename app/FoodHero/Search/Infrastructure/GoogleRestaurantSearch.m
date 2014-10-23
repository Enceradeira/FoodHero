//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "GoogleRestaurantSearch.h"
#import "DesignByContractException.h"
#import "SearchException.h"
#import "KeywordEncoder.h"
#import "GoogleOpeningHours.h"
#import "GoogleURL.h"

const NSUInteger GOOGLE_MAX_SEARCH_RESULTS = 200;
const NSUInteger GOOGLE_MAX_SEARCH_RADIUS = 50000;

@implementation GoogleRestaurantSearch {

    BOOL _simulateNetworkError;
}

- (id)init {
    self = [super init];
    if (self) {
        _baseAddress = @"https://maps.googleapis.com";
        _timeout = 60;
    }

    return self;
}

- (void)handleError:(NSError *)error {
    if (_simulateNetworkError) {
        @throw [SearchException createWithReason:@"simulated network error"];
    }
    if (error != nil) {
        @throw [SearchException createWithReason:[NSString stringWithFormat:@"Search failed: %@", error.description]];
    }
}

- (NSMutableArray *)findPlaces:(RestaurantSearchParams *)parameter {
    CLLocationDistance radius = parameter.radius;
    CLLocationCoordinate2D coordinate = parameter.coordinate;

    if (radius > GOOGLE_MAX_SEARCH_RADIUS) {
        @throw [DesignByContractException createWithReason:[NSString stringWithFormat:@"radius %f is greater that GOOGLE_MAX_SEARCH_RADIUS", radius]];
    }

    NSArray *types = @[@"restaurant", @"cafe"];
    NSString *typesAsString = [types componentsJoinedByString:@"%7C" /*pipe-character*/];
    NSString *keyword = [KeywordEncoder encodeString:parameter.cuisine];
    NSString *placeString = [NSString stringWithFormat:@"%@/maps/api/place/radarsearch/json?keyword=%@&location=%f,%f&radius=%u&minprice=%u&maxprice=%u&types=%@&key=AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg",
                                                       _baseAddress,
                                                       keyword,
                                                       coordinate.latitude,
                                                       coordinate.longitude,
                                                       (unsigned int) radius,
                                                       (unsigned int) parameter.minPriceLevel,
                                                       (unsigned int) parameter.maxPriceLevel,
                                                       typesAsString];

    NSDictionary *json = [self fetchJSON:placeString];

    NSMutableArray *restaurants = [NSMutableArray new];
    NSArray *places = json[@"results"];

    /* Following calculations assigns a relevance. The first places in the result-sets are more relevant.
     * Furthermore it accounts for the fact that when using a greater radius results seem to become less
     * specific therefore less relevant.
     *
     * minRelevance = radius * n + 1
     * 0            = radius * n + 1 ¦ radius == GOOGLE_MAX_SEARCH_RADIUS
     * n            = -1 / GOOGLE_MAX_SEARCH_RADIUS
     * minRelevance = (radius * -1 / GOOGLE_MAX_SEARCH_RADIUS) + 1
     * */
    double minRelevance = (-radius / GOOGLE_MAX_SEARCH_RADIUS) + 1;

    /* Following we calculate a linear function that assign relevance 1 to the first
     *  and relevance minRelevance to the last element
     *
     * relevance(place) = n*index(place) + 1
     * n = (relevance(place) - 1) / index(place)
    */
    double n;
    if (places.count > 1) {
        n = (minRelevance - 1) / (places.count - 1);  // for most irrelevant place (last one)
    }

    else {
        n = 0;
    }

    for (NSUInteger i = 0; i < places.count; i++) {
        NSDictionary *place = places[i];

        NSDictionary *geometryDic = [place valueForKey:@"geometry"];
        NSDictionary *locationDic = [geometryDic valueForKey:@"location"];
        double relevance = (n * i) + 1;

        CLLocation *location = [[CLLocation alloc] initWithLatitude:[[locationDic valueForKey:@"lat"] doubleValue]
                                                          longitude:[[locationDic valueForKey:@"lng"] doubleValue]];
        [restaurants addObject:[GooglePlace createWithPlaceId:[place valueForKey:@"place_id"]
                                                     location:location
                                             cuisineRelevance:relevance]];
    }
    return restaurants;
}

- (Restaurant *)getRestaurantForPlace:(GooglePlace *)place {
    NSString *placeString = [NSString stringWithFormat:@"%@/maps/api/place/details/json?placeid=%@&key=AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg", _baseAddress, place.placeId];

    NSDictionary *json = [self fetchJSON:placeString];

    NSArray *result = json[@"result"];

    NSDictionary *openingHours = [result valueForKey:@"opening_hours"];
    NSString *openingStatus = @"";
    NSString *openingHoursTodayDescription = @"";
    NSArray *openingHoursDescription = @[];
    if (openingHours) {
        openingStatus = [openingHours[@"open_now"] boolValue] ? @"Open now" : @"Closed now";
        NSArray *openingPeriods = openingHours[@"periods"];
        GoogleOpeningHours *hours = [GoogleOpeningHours createWithPeriods:openingPeriods];
        openingHoursTodayDescription = [hours descriptionForDate:[NSDate date]];
        openingHoursDescription = [hours descriptionForWeek];
    }
    NSString *website = [result valueForKey:@"website"];

    return [Restaurant createWithName:[result valueForKey:@"name"]
                             vicinity:[result valueForKey:@"vicinity"]
                              address:[self buildAddress:result]
                    addressComponents:[self buildAddressComponents:result]
                        openingStatus:openingStatus
                    openingHoursToday:openingHoursTodayDescription
                         openingHours:openingHoursDescription
                          phoneNumber:[result valueForKey:@"formatted_phone_number"]
                                  url:website
                     urlForDisplaying:[self buildUrlForDisplaying:website]
                                types:[result valueForKey:@"types"]
                              placeId:[result valueForKey:@"place_id"]
                             location:place.location
                           priceLevel:[[result valueForKey:@"price_level"] unsignedIntValue]
                     cuisineRelevance:place.cuisineRelevance];

}

- (NSArray *)buildAddressComponents:(NSArray *)result {
    NSArray *addressComponents = [[result valueForKey:@"address_components"] linq_select:^(NSDictionary *entry) {
        return entry[@"long_name"];
    }];
    return addressComponents;
}

- (NSString *)buildUrlForDisplaying:(NSString *)website {

    GoogleURL *googleURL = [GoogleURL create:website];
    return googleURL.userFriendlyURL;
}

- (NSString *)buildAddress:(NSArray *)result {
    NSString *formattedAddress = [result valueForKey:@"formatted_address"];
    NSString *seperator = @", ";
    NSArray *addressLines = [formattedAddress componentsSeparatedByString:seperator];
    NSUInteger nrAddressComponents = addressLines.count - 1; // last component is country which we don't want to output
    NSUInteger nrAddressComponentsLine1 = nrAddressComponents / 2;
    NSUInteger nrAddressComponentsLine2 = nrAddressComponents - nrAddressComponentsLine1;
    NSArray *addressComponentsLine1 = [addressLines linq_take:nrAddressComponentsLine1];
    NSArray *addressComponentsLine2 = [[addressLines linq_skip:nrAddressComponentsLine1] linq_take:nrAddressComponentsLine2];
    NSString *addressLine1 = [addressComponentsLine1 componentsJoinedByString:seperator];
    NSString *addressLine2 = [addressComponentsLine2 componentsJoinedByString:seperator];
    NSString *address = [NSString stringWithFormat:@"%@\n%@", addressLine1, addressLine2];
    return address;
}

- (void)simulateNetworkError:(BOOL)simulationEnabled {
    _simulateNetworkError = simulationEnabled;
}


- (NSDictionary *)fetchJSON:(NSString *)placeString {

    NSURL *placeURL = [NSURL URLWithString:placeString];
    NSError *error;

    NSURLRequest *request = [NSURLRequest requestWithURL:placeURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:_timeout];
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [self handleError:error];

    NSDictionary *json;
    @try {
        json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    }
    @catch (NSException *exp) {
        @throw;
    }

    [self handleError:error];
    return json;
}


/*
- (NSArray *)find2:(RestaurantSearchParams *)parameter {

    CLLocationCoordinate2D coordinate = parameter.location;

    NSArray *types = [NSArray arrayWithObjects:@"restaurant", @"cafe", @"food", nil];
    NSString *typesAsString = [types componentsJoinedByString:@"%7C"];
    NSString *placeString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%u&sensor=false&types=%@&key=AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg", coordinate.latitude, coordinate.longitude, parameter.radius, typesAsString];
    NSURL *placeURL = [NSURL URLWithString:placeString];

    NSError *error;
    NSData *responseData = [NSData dataWithContentsOfURL:placeURL options:NSDataReadingMappedIfSafe error:&error];

    NSDictionary *json;
    @try {
        json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    }
    @catch (NSException *exp) {
        @throw;
    }

    NSArray *places = [json objectForKey:@"results"];
    NSMutableArray *restaurants = [NSMutableArray new];

    for (NSDictionary *place in places) {

        [restaurants addObject:[Restaurant
                createWithName:[place valueForKey:@"name"]
                      vicinity:[place valueForKey:@"vicinity"]
                         types:[place valueForKey:@"types"]
                       placeId:[place valueForKey:@"place_id"]
        ]];
    }
    return restaurants;
}

- (void)textsearch {
    NSString *placeString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=indian+restaurant&key=AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg"];
    NSURL *placeURL = [NSURL URLWithString:placeString];

    NSError *error;
    NSData *responseData = [NSData dataWithContentsOfURL:placeURL options:NSDataReadingMappedIfSafe error:&error];

    NSDictionary *json;
    @try {
        json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    }
    @catch (NSException *exp) {
        @throw;
    }
}

*/


@end