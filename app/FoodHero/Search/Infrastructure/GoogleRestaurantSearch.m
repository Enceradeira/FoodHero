//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "GoogleRestaurantSearch.h"
#import "RestaurantSearchParams.h"


@implementation GoogleRestaurantSearch {

}
- (NSArray *)find:(RestaurantSearchParams *)parameter {

    CLLocationCoordinate2D coordinate = parameter.location;
    NSString *placeString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=2000&sensor=false&key=AIzaSyDL2sUACGU8SipwKgj-mG-cl3Sik1qJGjg",coordinate.latitude,coordinate.longitude];
    NSURL *placeURL = [NSURL URLWithString:placeString];

    NSData *responseData = [NSData dataWithContentsOfURL:placeURL];

    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];

    NSArray *places = [json objectForKey:@"results"];
    NSMutableArray *restaurants = [NSMutableArray new];

    for(NSDictionary *place in places){

        [restaurants addObject:[Restaurant createWithName:[place valueForKey:@"name"] withVicinity:[place valueForKey:@"vicinity"]]];
    }
    return restaurants;
}

@end