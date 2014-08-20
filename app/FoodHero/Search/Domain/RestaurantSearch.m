//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "RestaurantSearch.h"
#import "NoRestaurantsFoundError.h"
#import "NSArray+LinqExtensions.h"
#import "USuggestionNegativeFeedback.h"
#import "SearchParameter.h"

@implementation RestaurantSearch {

    id <IRestaurantRepository> _repository;
}

- (instancetype)initWithRestaurantRepository:(id <IRestaurantRepository>)repository {
    self = [super init];
    if (self != nil) {
        _repository = repository;
    }
    return self;
}

- (RACSignal *)findBest:(id <ConversationSource>)conversation {
    SearchParameter *searchPreference = conversation.currentSearchPreference;

    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        __block NSMutableArray *candidates = [NSMutableArray new];

        RACSignal *placesSignal = [_repository getPlacesByCuisineOrderedByDistance:searchPreference.cuisine];
        RACDisposable *placesDisposable = [placesSignal subscribeNext:
                        ^(GooglePlace *p) {
                            [candidates addObject:p];
                        }
                                                                error:^(NSError *e) {
                                                                    [subscriber sendError:e];
                                                                } completed:^() {

                    if (candidates.count > 0) {
                        NSArray *excludedPlaceIds = [conversation.negativeUserFeedback linq_select:^(USuggestionNegativeFeedback *f) {
                            return f.restaurant.placeId;
                        }];

                        NSArray *places = [candidates linq_where:^(GooglePlace *p) {
                            return [excludedPlaceIds linq_all:^(NSString *id) {
                                return (BOOL) (![p.placeId isEqualToString:id]);
                            }];
                        }];

                        [subscriber sendNext:[_repository getRestaurantFromPlace:places[0]]];
                        [subscriber sendCompleted];
                    }
                    else {
                        [subscriber sendError:[NoRestaurantsFoundError new]];
                    }
                }];

        RACSerialDisposable *serialDisposable = [RACSerialDisposable new];
        serialDisposable.disposable = placesDisposable;
        return serialDisposable;
    }];
}
@end