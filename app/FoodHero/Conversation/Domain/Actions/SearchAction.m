//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "SearchAction.h"
#import "NoRestaurantsFoundError.h"
#import "LocationServiceAuthorizationStatusRestrictedError.h"
#import "LocationServiceAuthorizationStatusDeniedError.h"
#import "FHBecauseUserDeniedAccessToLocationServices.h"
#import "FHBecauseUserIsNotAllowedToUseLocationServices.h"
#import "FHNoRestaurantsFound.h"
#import "FHSuggestion.h"
#import "TyphoonComponents.h"
#import "TokenRandomizer.h"
#import "TagAndToken.h"
#import "FHSuggestionAsFollowUp.h"
#import "USuggestionFeedback.h"


@implementation SearchAction {

    RestaurantSearch *_restaurantSearch;
    id <ConversationSource> _conversation;
    id <TokenRandomizer> _tokenRandomizer;
}
+ (SearchAction *)create:(id <ConversationSource>)actionFeedback {
    return [[SearchAction alloc] initWithFeedback:actionFeedback];
}

- (id)initWithFeedback:(id <ConversationSource>)conversation {
    self = [super init];
    if (self != nil) {
        _conversation = conversation;
        _restaurantSearch = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearch];
        _tokenRandomizer = [(id <ApplicationAssembly>) [TyphoonComponents factory] tokenRandomizer];
    }
    return self;
}

- (void)execute {
    USuggestionFeedback *lastFeedback = [_conversation.suggestionFeedback linq_lastOrNil];

    RACSignal *bestRestaurant = [_restaurantSearch findBest:_conversation.suggestionFeedback];
    @weakify(self);
    [bestRestaurant subscribeError:^(NSError *error){
        @strongify(self);
        if (error.class == [LocationServiceAuthorizationStatusDeniedError class]) {
            [_conversation addToken:[FHBecauseUserDeniedAccessToLocationServices create]];
        }
        else if (error.class == [LocationServiceAuthorizationStatusRestrictedError class]) {
            [_conversation addToken:[FHBecauseUserIsNotAllowedToUseLocationServices create]];
        }
        else if (error.class == [NoRestaurantsFoundError class]) {
            [_conversation addToken:[FHNoRestaurantsFound create]];
        }
    }];
    [bestRestaurant subscribeNext:^(id next){
        @strongify(self);
        Restaurant *restaurant = next;

        if (lastFeedback != nil && lastFeedback.restaurant != nil) {
            // Food Hero has already suggested a restaurant before
            NSArray *tagAndSymbols = [NSArray arrayWithObjects:
                    [TagAndToken create:@"FH:Suggestion" token:[FHSuggestion create:restaurant]],
                    [TagAndToken create:@"FH:SuggestionAsFollowUp" token:[FHSuggestionAsFollowUp create:restaurant]], nil];

            [_conversation addToken:[_tokenRandomizer chooseOneToken:tagAndSymbols]];

            [_tokenRandomizer doOptionally:@"FH:Comment" byCalling:^(){
               [_conversation addToken:[lastFeedback foodHeroConfirmationToken]];
            }];
        }
        else {
            [_conversation addToken:[FHSuggestion create:restaurant]];
        }

    }];
}


@end