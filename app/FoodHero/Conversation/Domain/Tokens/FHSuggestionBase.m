//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionBase.h"
#import "DesignByContractException.h"

@implementation FHSuggestionBase {

}

- (instancetype)initWithRestaurant:(Restaurant *)restaurant {
    NSString *nameAndPlace = [NSString stringWithFormat:@"%@, %@", restaurant.name, restaurant.vicinity];
    NSString *text = [[NSString alloc] initWithFormat:[self getText], nameAndPlace];

    self = [super initWithParameter:[NSString stringWithFormat:@"%@=%@", [self getTokenName], nameAndPlace] parameter:text];
    if (self != nil) {
        _restaurant = restaurant;
    }
    return self;
}

- (NSString *)getTokenName {
    @throw [DesignByContractException createWithReason:@"methode must be overridden"];
}

- (NSString *)getText {
    @throw [DesignByContractException createWithReason:@"methode must be overridden"];
}

@end