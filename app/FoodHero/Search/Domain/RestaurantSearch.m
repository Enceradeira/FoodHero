//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "RestaurantSearch.h"
#import "NoRestaurantsFoundError.h"
#import "NSArray+LinqExtensions.h"
#import "USuggestionNegativeFeedback.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"

@implementation RestaurantSearch {

    id <RestaurantSearchService> _searchService;
    LocationService *_locationService;
}

- (id)initWithSearchService:(id <RestaurantSearchService>)searchService withLocationService:(LocationService *)locationService {
    self = [super init];
    if (self != nil) {
        _searchService = searchService;
        _locationService = locationService;
    }
    return self;
}

- (RACSignal *)findBest:(NSArray *)userFeedback {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber){
        RACSerialDisposable *serialDisposable = [RACSerialDisposable new];

        RACDisposable *sourceDisposable = [[_locationService currentLocation]
                subscribeNext:^(id value){
                    CLLocationCoordinate2D coordinate;
                    coordinate.longitude, coordinate.latitude = 0;
                    [((NSValue *) value) getValue:&coordinate];

                    RestaurantSearchParams *parameter = [RestaurantSearchParams new];
                    parameter.location = coordinate;
                    parameter.radius = 2000;
                    NSArray *candidates = [_searchService find:parameter];
                    if (candidates.count > 0) {
                        NSArray *excludedPlaceIds = [[userFeedback linq_where:^(USuggestionNegativeFeedback *f){
                            return (BOOL) ([f isKindOfClass:[USuggestionFeedbackForNotLikingAtAll class]]);
                        }] linq_select:^(USuggestionNegativeFeedback *f){
                            return f.restaurant.placeId;
                        }];

                        NSArray *restaurants = [candidates linq_where:^(Restaurant *r){
                            return [excludedPlaceIds linq_all:^(NSString *id){
                                return (BOOL) (![r.placeId isEqualToString:id]);
                            }];
                        }];

                        [subscriber sendNext:restaurants[0]];
                        [subscriber sendCompleted];
                    }
                    else {
                        [subscriber sendError:[NoRestaurantsFoundError new]];
                    }
                } error:^(NSError *error) {
                    [subscriber sendError:error];
                }   completed:^{
                    [subscriber sendCompleted];
                }];

        serialDisposable.disposable = sourceDisposable;
        return serialDisposable;
    }];
}
@end