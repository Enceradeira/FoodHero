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
#import "USuggestionNegativeFeedback.h"
#import "FHConfirmation.h"
#import "SearchProfil.h"
#import "FHWarningIfNotInPreferredRangeTooCheap.h"
#import "FHSuggestionAfterWarning.h"


@implementation SearchAction {

    RestaurantSearch *_restaurantSearch;
    id <TokenRandomizer> _tokenRandomizer;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _restaurantSearch = [(id <ApplicationAssembly>) [TyphoonComponents factory] restaurantSearch];
        _tokenRandomizer = [(id <ApplicationAssembly>) [TyphoonComponents factory] tokenRandomizer];
    }
    return self;
}


- (void)execute:(id<ConversationSource>)conversation {
    USuggestionNegativeFeedback *lastFeedback = [conversation.negativeUserFeedback linq_lastOrNil];

    RACSignal *bestRestaurant = [_restaurantSearch findBest:conversation];
    @weakify(self);
    [bestRestaurant subscribeError:^(NSError *error){
        @strongify(self);
        if (error.class == [LocationServiceAuthorizationStatusDeniedError class]) {
            [conversation addToken:[FHBecauseUserDeniedAccessToLocationServices create]];
        }
        else if (error.class == [LocationServiceAuthorizationStatusRestrictedError class]) {
            [conversation addToken:[FHBecauseUserIsNotAllowedToUseLocationServices create]];
        }
        else if (error.class == [NoRestaurantsFoundError class]) {
            [conversation addToken:[FHNoRestaurantsFound create]];
        }
    }];
    [bestRestaurant subscribeNext:^(id next){
        @strongify(self);
        Restaurant *restaurant = next;

        if (lastFeedback != nil && lastFeedback.restaurant != nil) {
            // Food Hero has already suggested a restaurant before
            ConversationToken *fhSuggestionToken = [FHSuggestion create:restaurant];
            ConversationToken *fhSuggestionAsFollowUp = [FHSuggestionAsFollowUp create:restaurant];
            ConversationToken *fhSuggestionWithComment = [lastFeedback getFoodHeroSuggestionWithCommentToken:restaurant];

            SearchProfil *searchPreference = conversation.currentSearchPreference;
            if( searchPreference.priceRange.min >= restaurant.priceLevel){
                [conversation addToken:[FHWarningIfNotInPreferredRangeTooCheap create]];
                [conversation addToken:[FHSuggestionAfterWarning create:restaurant]];
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
                [conversation addToken:chosenToken];

                if (chosenToken == fhSuggestionAsFollowUp && [lastFeedback foodHeroConfirmationToken] != nil) {
                    [_tokenRandomizer doOptionally:@"FH:Comment" byCalling:^() {
                        [conversation addToken:[lastFeedback foodHeroConfirmationToken]];
                    }];
                }
                else if (chosenToken == fhSuggestionWithComment) {
                    [conversation addToken:[FHConfirmation create]];
                }
            }
        }
        else {
            [conversation addToken:[FHSuggestion create:restaurant]];
        }

    }];
}


@end