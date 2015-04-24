//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import <ReactiveCocoa.h>
#import "GoogleRestaurantSearch.h"
#import "DesignByContractException.h"
#import "SearchException.h"
#import "KeywordEncoder.h"
#import "GoogleOpeningHours.h"
#import "GoogleURL.h"
#import "GoogleDefinitions.h"
#import "GooglePhoto.h"
#import "FoodHero-Swift.h"


@implementation GoogleRestaurantSearch {

    BOOL _simulateNetworkError;
    NSOperationQueue *_queue;
    id <IEnvironment> _environment;
    BOOL _onlyOpenNow;
}

- (id)initWithEnvironment:(id <IEnvironment>)environment onlyOpenNow:(BOOL)onlyOpenNow {
    self = [super init];
    if (self) {
        _baseAddress = GOOGLE_BASE_ADDRESS;
        _timeout = 60;
        _queue = [[NSOperationQueue alloc] init];
        _environment = environment;
        _onlyOpenNow = onlyOpenNow;
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

    NSArray *types = [OccasionToGoogleTypeMapper map:parameter.cuisineAndOccasion.occasion];
    NSString *typesAsString = [types componentsJoinedByString:@"%7C" /*pipe-character*/];
    NSString *keyword = [KeywordEncoder encodeString:parameter.cuisineAndOccasion.cuisine];
    NSString *placeString = [NSString stringWithFormat:@"%@/maps/api/place/radarsearch/json?keyword=%@&location=%f,%f&radius=%u&minprice=%u&maxprice=%u&types=%@&key=%@%@",
                                                       _baseAddress,
                                                       keyword,
                                                       coordinate.latitude,
                                                       coordinate.longitude,
                                                       (unsigned int) radius,
                                                       (unsigned int) parameter.minPriceLevel,
                                                       (unsigned int) parameter.maxPriceLevel,
                                                       typesAsString,
                                                       GOOGLE_API_KEY,
                                                       _onlyOpenNow ? @"&opennow" : @""];

    __block NSDictionary *json;
    NSError *error;
    RACSignal *fetchSignal = [self fetchJSON:placeString];
    [fetchSignal subscribeNext:^(NSDictionary *j) {
        json = j;
    }];
    [fetchSignal waitUntilCompleted:&error];
    [self handleError:error];

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

- (Restaurant *)createRestaurantFromPlace:(GooglePlace *)place details:(NSArray *)details distance:(NSNumber *)distance {
    NSDictionary *openingHours = [details valueForKey:@"opening_hours"];
    NSString *openingStatus = @"";
    NSString *openingHoursTodayDescription = @"";
    NSArray *openingHoursDescription = @[];
    if (openingHours) {
        openingStatus = [openingHours[@"open_now"] boolValue] ? @"Open now" : @"Closed now";
        NSArray *openingPeriods = openingHours[@"periods"];
        GoogleOpeningHours *hours = [GoogleOpeningHours createWithPeriods:openingPeriods environment:_environment];
        openingHoursTodayDescription = [hours descriptionForDate:[NSDate date]];
        openingHoursDescription = [hours descriptionForWeek];
    }
    NSString *website = [details valueForKey:@"website"];

    NSArray *reviews = [[details valueForKey:@"reviews"] linq_select:^(NSDictionary *review) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[review[@"time"] doubleValue]];
        return [RestaurantReview create:review[@"text"] rating:[review[@"rating"] doubleValue] author:review[@"author_name"] date:date];
    }];
    NSNumber *ratingNumber = [details valueForKey:@"rating"];
    RestaurantRating *rating = [RestaurantRating createRating:[ratingNumber doubleValue] withReviews:reviews];
    __block NSUInteger countPhotos = 0;
    NSArray *photos = [[details valueForKey:@"photos"] linq_select:^(NSDictionary *photo) {
        countPhotos++;
        return [GooglePhoto create:photo[@"photo_reference"] height:[photo[@"height"] unsignedIntValue] width:[photo[@"width"] unsignedIntValue] loadEagerly:countPhotos == 1];
    }];
    return [Restaurant createWithName:[details valueForKey:@"name"]
                             vicinity:[details valueForKey:@"vicinity"]
                              address:[self buildAddress:details]
                    addressComponents:[self buildAddressComponents:details]
                        openingStatus:openingStatus
                    openingHoursToday:openingHoursTodayDescription
                         openingHours:openingHoursDescription
                          phoneNumber:[details valueForKey:@"formatted_phone_number"]
                                  url:website
                     urlForDisplaying:[self buildUrlForDisplaying:website]
                                types:[details valueForKey:@"types"]
                              placeId:[details valueForKey:@"place_id"]
                             location:place.location
                             distance:distance.doubleValue
                           priceLevel:[[details valueForKey:@"price_level"] unsignedIntValue]
                     cuisineRelevance:place.cuisineRelevance
                               rating:rating
                               photos:photos];
}

- (Restaurant *)getRestaurantForPlace:(GooglePlace *)place currentLocation:(CLLocation *)currentLocation {
    __block Restaurant *restaurant;

    RACSignal *detailsSignal = [self fetchPlaceDetails:place];
    RACSignal *directionsSignal = [self fetchPlaceDirections:place currentLocation:currentLocation];
    RACSignal *restaurantSignal = [RACSignal combineLatest:@[detailsSignal, directionsSignal]
                                                    reduce:^(NSArray *details, NSNumber *distance) {
                                                        return [self createRestaurantFromPlace:place details:details distance:distance];
                                                    }];


    [restaurantSignal subscribeNext:^(Restaurant *r) {
        restaurant = r;
    }];
    NSError *error;
    [restaurantSignal waitUntilCompleted:&error];
    [self handleError:error];

    return restaurant;
}

- (RACSignal *)fetchPlaceDirections:(GooglePlace *)place currentLocation:(CLLocation *)currentLocation {
    CLLocationCoordinate2D currentCoordinate = currentLocation.coordinate;
    CLLocationCoordinate2D placeCoordinate = place.location.coordinate;
    NSString *placeString = [NSString stringWithFormat:@"%@/maps/api/directions/json?origin=%f,%f&destination=%f,%f&key=%@",
                                                       _baseAddress,
                                                       currentCoordinate.latitude,
                                                       currentCoordinate.longitude,
                                                       placeCoordinate.latitude,
                                                       placeCoordinate.longitude,
                                                       GOOGLE_API_KEY];

    return [[self fetchJSON:placeString] map:^(NSDictionary *json) {

        NSArray *routes = json[@"routes"];
        NSArray *legs = [routes linq_selectMany:^(NSDictionary *route) {
            return route[@"legs"];
        }];
        NSArray *distances = [legs linq_select:^(NSDictionary *leg) {
            NSDictionary *distance = leg[@"distance"];
            return distance[@"value"];
        }];

        double meters = 0;
        for (NSNumber *distance in distances) {
            meters += [distance doubleValue];
        }
        return @(meters);
    }];
}

- (RACSignal *)fetchPlaceDetails:(GooglePlace *)place {
    NSString *placeString = [NSString stringWithFormat:@"%@/maps/api/place/details/json?placeid=%@&key=AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg", _baseAddress, place.placeId];

    return [[self fetchJSON:placeString] map:^(NSDictionary *json) {
        return json[@"result"];
    }];
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


- (RACSignal *)fetchJSON:(NSString *)placeString {

    NSURL *placeURL = [NSURL URLWithString:placeString];
    NSURLRequest *request = [NSURLRequest requestWithURL:placeURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:_timeout];

    return [RACSignal startEagerlyWithScheduler:[RACScheduler scheduler] block:^(id <RACSubscriber> subscriber) {

        [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                NSDictionary *json;

                NSError *jsonError;
                json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                if (jsonError) {
                    [subscriber sendError:jsonError];
                }
                else {
                    [subscriber sendNext:json];
                }
            }
            [subscriber sendCompleted];
        }];
    }];
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