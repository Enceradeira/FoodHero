//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionAsFollowUp.h"
#import "Restaurant.h"


@implementation FHSuggestionAsFollowUp {

}
+ (instancetype)create:(Restaurant *)restaurant {
    return [[FHSuggestionAsFollowUp alloc] initWithRestaurant:restaurant];
}

- (instancetype)initWithRestaurant:(Restaurant *)restaurant {
    NSString *nameAndPlace = [NSString stringWithFormat:@"%@, %@", restaurant.name, restaurant.vicinity];
    NSString *text = [[NSString alloc] initWithFormat:@"What about '%@' then?", nameAndPlace];
    NSString *sanitizedName = [nameAndPlace stringByReplacingOccurrencesOfString:@"'" withString:@""];

    self = [super initWithParameter:[NSString stringWithFormat:@"FH:SuggestionAsFollowUp=%@", sanitizedName] parameter:text];
    if (self != nil) {
        _restaurant = restaurant;
    }
    return self;
}
@end