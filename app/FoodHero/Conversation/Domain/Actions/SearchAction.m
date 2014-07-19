//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import "SearchAction.h"
#import "NoRestaurantsFoundError.h"
#import "LocationServiceAuthorizationStatusRestrictedError.h"
#import "LocationServiceAuthorizationStatusDeniedError.h"
#import "FHBecauseUserDeniedAccessToLocationServices.h"
#import "FHBecauseUserIsNotAllowedToUseLocationServices.h"
#import "FHNoRestaurantsFound.h"
#import "FHSuggestion.h"


@implementation SearchAction {

    RestaurantSearch *_restaurantSearch;
    id <ConversationSource> _feedbackTarget;
}
+ (SearchAction *)create:(id <ConversationSource>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch {
    return [[SearchAction alloc] initWithFeedback:actionFeedback restaurantSearch:restaurantSearch];
}

- (id)initWithFeedback:(id <ConversationSource>)feedbackTarget restaurantSearch:(RestaurantSearch *)search {
    self = [super init];
    if (self != nil) {
        _feedbackTarget = feedbackTarget;
        _restaurantSearch = search;
    }
    return self;
}

- (void)execute {
    RACSignal *bestRestaurant = [_restaurantSearch findBest:_feedbackTarget.suggestionFeedback];
    @weakify(self);
    [bestRestaurant subscribeError:^(NSError *error){
        @strongify(self);
        if (error.class == [LocationServiceAuthorizationStatusDeniedError class]) {
            [_feedbackTarget addToken:[FHBecauseUserDeniedAccessToLocationServices create]];
        }
        else if (error.class == [LocationServiceAuthorizationStatusRestrictedError class]) {
            [_feedbackTarget addToken:[FHBecauseUserIsNotAllowedToUseLocationServices create]];
        }
        else if (error.class == [NoRestaurantsFoundError class]) {
            [_feedbackTarget addToken:[FHNoRestaurantsFound create]];
        }
    }];
    [bestRestaurant subscribeNext:^(id next){
        @strongify(self);
        Restaurant *restaurant = next;
        NSString *nameAndPlace = [NSString stringWithFormat:@"%@, %@", restaurant.name, restaurant.vicinity];
        [_feedbackTarget addToken:[FHSuggestion create:nameAndPlace]];
    }];
}


@end