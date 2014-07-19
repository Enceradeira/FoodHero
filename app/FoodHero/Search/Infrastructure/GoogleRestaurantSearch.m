//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "GoogleRestaurantSearch.h"

@implementation GoogleRestaurantSearch {

}
- (NSArray *)find:(RestaurantSearchParams *)parameter {

    CLLocationCoordinate2D coordinate = parameter.location;

    NSArray *types = [NSArray arrayWithObjects:@"restaurant", @"cafe", @"food", nil];
    NSString *typesAsString = [types componentsJoinedByString:@"%7C" /*pipe-character*/];
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

@end