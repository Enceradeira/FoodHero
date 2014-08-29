//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "GoogleRestaurantSearch.h"

const NSUInteger GOOGLE_MAX_SEARCH_RESULTS = 200;
const NSUInteger GOOGLE_MAX_SEARCH_RADIUS = 50000;

@implementation GoogleRestaurantSearch {

}

- (NSMutableArray *)findPlaces:(RestaurantSearchParams *)parameter {
    CLLocationCoordinate2D coordinate = parameter.coordinate;

    NSArray *types = @[@"restaurant", @"cafe", @"food"];
    NSString *typesAsString = [types componentsJoinedByString:@"%7C" /*pipe-character*/];
    NSString *keyword = [parameter.cuisine stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *placeString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/radarsearch/json?keyword=%@&location=%f,%f&radius=%u&minprice=%u&maxprice=%u&types=%@&key=AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg",
                                                       keyword,
                                                       coordinate.latitude,
                                                       coordinate.longitude,
                                                       (unsigned int) parameter.radius,
                                                       parameter.minPriceLevel,
                                                       parameter.maxPriceLevel,
                                                       typesAsString];

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

    NSMutableArray *restaurants = [NSMutableArray new];
    NSArray *places = json[@"results"];

    // relevance(place) = n*index(place) + 1
    // n = (relevance(place) - 1) / index(place)
    double n = (double)(0-1) / (places.count - 1);

    for(NSUInteger i=0; i<places.count; i++){
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
    NSString *placeString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg", place.placeId];
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

    NSArray *result = json[@"result"];
    return [Restaurant createWithName:[result valueForKey:@"name"]
                             vicinity:[result valueForKey:@"vicinity"]
                                types:[result valueForKey:@"types"]
                              placeId:[result valueForKey:@"place_id"]
                             location:place.location
                           priceLevel:[[result valueForKey:@"price_level"] unsignedIntValue]
                     cuisineRelevance:place.cuisineRelevance];

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