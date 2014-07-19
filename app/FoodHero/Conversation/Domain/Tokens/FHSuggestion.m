//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestion.h"
#import "Restaurant.h"


@implementation FHSuggestion {

}
+ (instancetype)create:(Restaurant *)restaurant {
    return [[FHSuggestion alloc] initWithRestaurant:restaurant];
}

- (instancetype)initWithRestaurant:(Restaurant *)restaurant {
    NSString *nameAndPlace = [NSString stringWithFormat:@"%@, %@", restaurant.name, restaurant.vicinity];
    NSString *text = [[NSString alloc] initWithFormat:@"Maybe you like the '%@'?", nameAndPlace];
    NSString *sanitizedName = [nameAndPlace stringByReplacingOccurrencesOfString:@"'" withString:@""];

    self = [super initWithParameter:[NSString stringWithFormat:@"FH:Suggestion=%@", sanitizedName] parameter:text];
    if (self != nil) {
        _restaurant = restaurant;
    }
    return self;
}
@end