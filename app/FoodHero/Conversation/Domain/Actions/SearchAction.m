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
#import "Randomizer.h"
#import "TagAndToken.h"
#import "FHSuggestionAsFollowUp.h"
#import "USuggestionNegativeFeedback.h"
#import "FHConfirmation.h"
#import "SearchProfil.h"
#import "FHWarningIfNotInPreferredRangeTooCheap.h"
#import "FHSuggestionAfterWarning.h"
#import "FHWarningIfNotInPreferredRangeTooExpensive.h"
#import "FHWarningIfNotInPreferredRangeTooFarAway.h"
#import "SearchError.h"


@implementation SearchAction {

    RestaurantSearch *_restaurantSearch;
    id <Randomizer> _tokenRandomizer;
    LocationService *_locationService;
    id <ISchedulerFactory> _schedulerFactory;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _restaurantSearch = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearch];
        _tokenRandomizer = [(id <ApplicationAssembly>) [TyphoonComponents factory] randomizer];
        _locationService = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationService];
        _schedulerFactory = [(id <ApplicationAssembly>) [TyphoonComponents factory] schedulerFactory];
    }
    return self;
}


- (void)execute:(id <ConversationSource>)conversation {
    USuggestionNegativeFeedback *lastFeedback = [conversation.negativeUserFeedback linq_lastOrNil];

    RACSignal *bestRestaurant = [[_restaurantSearch findBest:conversation]
            deliverOn:_schedulerFactory.mainThreadScheduler];
    [bestRestaurant subscribeError:^(NSError *error) {
        if (error.class == [LocationServiceAuthorizationStatusDeniedError class]) {
            [conversation addFHToken:[FHBecauseUserDeniedAccessToLocationServices create]];
        }
        else if (error.class == [LocationServiceAuthorizationStatusRestrictedError class]) {
            [conversation addFHToken:[FHBecauseUserIsNotAllowedToUseLocationServices create]];
        }
        else if (error.class == [NoRestaurantsFoundError class]) {
            [conversation addFHToken:[FHNoRestaurantsFound create]];
        }
        else if (error.class == [SearchError class]) {
            [conversation addFHToken:[FHNoRestaurantsFound create]];
        }
    }];
    [bestRestaurant subscribeNext:^(id next) {
        Restaurant *restaurant = next;

        if (lastFeedback != nil && lastFeedback.restaurant != nil) {
            // Food Hero has already suggested a restaurant before
            ConversationToken *fhSuggestionToken = [FHSuggestion create:restaurant];
            ConversationToken *fhSuggestionAsFollowUp = [FHSuggestionAsFollowUp create:restaurant];
            ConversationToken *fhSuggestionWithComment = [lastFeedback getFoodHeroSuggestionWithCommentToken:restaurant];

            SearchProfil *searchPreference = conversation.currentSearchPreference;
            ConversationToken *lastSuggestionWarning = conversation.lastSuggestionWarning;
            PriceRange *priceRange = searchPreference.priceRange;
            if (priceRange.min > restaurant.priceLevel && ![lastSuggestionWarning isKindOfClass:[FHWarningIfNotInPreferredRangeTooCheap class]]) {
                [conversation addFHToken:[FHWarningIfNotInPreferredRangeTooCheap create]];
                [conversation addFHToken:[FHSuggestionAfterWarning create:restaurant]];
            }
            else if (priceRange.max < restaurant.priceLevel && ![lastSuggestionWarning isKindOfClass:[FHWarningIfNotInPreferredRangeTooExpensive class]]) {
                [conversation addFHToken:[FHWarningIfNotInPreferredRangeTooExpensive create]];
                [conversation addFHToken:[FHSuggestionAfterWarning create:restaurant]];
            }
            else if (searchPreference.distanceRange.max < [restaurant.location distanceFromLocation:_locationService.lastKnownLocation]
                    && ![lastSuggestionWarning isKindOfClass:[FHWarningIfNotInPreferredRangeTooFarAway class]]) {
                [conversation addFHToken:[FHWarningIfNotInPreferredRangeTooFarAway create]];
                [conversation addFHToken:[FHSuggestionAfterWarning create:restaurant]];
            }
            else {
                NSMutableArray *tagAndSymbols = [NSMutableArray new];
                [tagAndSymbols addObject:[TagAndToken create:@"FH:Suggestion" token:fhSuggestionToken]];
                if (fhSuggestionAsFollowUp != nil) {
                    [tagAndSymbols addObject:[TagAndToken create:@"FH:SuggestionAsFollowUp" token:fhSuggestionAsFollowUp]];
                }
                if (fhSuggestionWithComment != nil) {
                    [tagAndSymbols addObject:[TagAndToken create:@"FH:SuggestionWithComment" token:fhSuggestionWithComment]];
                }

                ConversationToken *chosenToken = [_tokenRandomizer chooseOneToken:tagAndSymbols];
                [conversation addFHToken:chosenToken];

                if (chosenToken == fhSuggestionAsFollowUp && [lastFeedback foodHeroConfirmationToken] != nil) {
                    [_tokenRandomizer doOptionally:@"FH:Comment" byCalling:^() {
                        [conversation addFHToken:[lastFeedback foodHeroConfirmationToken]];
                    }];
                }
                else if (chosenToken == fhSuggestionWithComment) {
                    [conversation addFHToken:[FHConfirmation create]];
                }
            }
        }
        else {
            [conversation addFHToken:[FHSuggestion create:restaurant]];
        }

    }];
}


@end