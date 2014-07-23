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
#import "TyphoonComponents.h"
#import "AlternationRandomizer.h"
#import "TagAndToken.h"
#import "FHSuggestionAsFollowUp.h"
#import "FHFirstProposalState.h"


@implementation SearchAction {

    RestaurantSearch *_restaurantSearch;
    id <ConversationSource> _conversation;
    id <AlternationRandomizer> _alternationRandomizer;
}
+ (SearchAction *)create:(id <ConversationSource>)actionFeedback {
    return [[SearchAction alloc] initWithFeedback:actionFeedback];
}

- (id)initWithFeedback:(id <ConversationSource>)conversation {
    self = [super init];
    if (self != nil) {
        _conversation = conversation;
        _restaurantSearch = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearch];
        _alternationRandomizer = [(id <ApplicationAssembly>) [TyphoonComponents factory] alternationRandomizer];
    }
    return self;
}

- (void)execute {
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

        ConversationToken *symbol;
        if ([_conversation hasState:[FHFirstProposalState class]]) {
            NSArray *tagAndSymbols = [NSArray arrayWithObjects:
                    [TagAndToken create:@"FH:Suggestion" token:[FHSuggestion create:restaurant]],
                    [TagAndToken create:@"FH:SuggestionAsFollowUp" token:[FHSuggestionAsFollowUp create:restaurant]], nil];

            symbol = [_alternationRandomizer chooseOneToken:tagAndSymbols];
        }
        else {
            symbol = [FHSuggestion create:restaurant];
        }

        [_conversation addToken:symbol];
    }];
}


@end