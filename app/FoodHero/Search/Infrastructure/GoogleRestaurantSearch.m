//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import <ReactiveCocoa.h>
#import "GoogleRestaurantSearch.h"
#import "SearchException.h"
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

- (Restaurant *)createRestaurantFromPlace:(GooglePlace *)place details:(NSArray *)details distance:(RestaurantDistance *)distance {
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
                             distance:distance
                           priceLevel:[[details valueForKey:@"price_level"] unsignedIntValue]
                     cuisineRelevance:place.cuisineRelevance
                               rating:rating
                               photos:photos];
}

- (Restaurant *)getRestaurantForPlace:(GooglePlace *)place searchLocation:(ResolvedSearchLocation *)searchLocation {
    __block Restaurant *restaurant;

    RACSignal *detailsSignal = [self fetchPlaceDetails:place];
    RACSignal *directionsSignal = [self fetchPlaceDirections:place searchLocation:searchLocation.location];
    RACSignal *restaurantSignal = [RACSignal combineLatest:@[detailsSignal, directionsSignal]
                                                    reduce:^(NSArray *details, NSNumber *distance) {
                                                        RestaurantDistance *restaurantLocation = [[RestaurantDistance alloc] initWithSearchLocation:searchLocation.location
                                                                                                                          searchLocationDescription:searchLocation.locationDescription
                                                                                                                         distanceFromSearchLocation:distance.doubleValue];

                                                        return [self createRestaurantFromPlace:place details:details distance:restaurantLocation];
                                                    }];


    [restaurantSignal subscribeNext:^(Restaurant *r) {
        restaurant = r;
    }];
    NSError *error;
    [restaurantSignal waitUntilCompleted:&error];
    [self handleError:error];

    return restaurant;
}

- (RACSignal *)fetchPlaceDirections:(GooglePlace *)place searchLocation:(CLLocation *)searchLocation {
    CLLocationCoordinate2D currentCoordinate = searchLocation.coordinate;
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

        if (meters == 0) {
            meters = [place.location distanceFromLocation:searchLocation];
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
@end