//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "RestaurantSearch.h"
#import "NoRestaurantsFoundError.h"
#import "NSArray+LinqExtensions.h"
#import "USuggestionNegativeFeedback.h"
#import "RadiusCalculator.h"

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

- (RACSignal *)findBest:(id <ConversationSource>)conversation {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        RACSerialDisposable *serialDisposable = [RACSerialDisposable new];

        RACDisposable *sourceDisposable = [[_locationService currentLocation]
                subscribeNext:^(id value) {
                    CLLocationCoordinate2D coordinate;
                    [((NSValue *) value) getValue:&coordinate];
                    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];

                    // dynamically adjust radius in order to get as specific results as possible
                    NSArray *candidates = [RadiusCalculator doUntilRightNrOfElementsReturned:^(double radius) {
                        RestaurantSearchParams *parameter = [RestaurantSearchParams new];
                        parameter.coordinate = coordinate;
                        parameter.radius = radius;
                        parameter.cuisine = conversation.cuisine;
                        parameter.minPrice = 0;
                        parameter.maxPrice = 4;
                        return [_searchService findPlaces:parameter];
                    }];

                    candidates = [candidates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                        CLLocationDistance distanceA = [[((Place *) a) location] distanceFromLocation:currentLocation];
                        CLLocationDistance distanceB = [[((Place *) b) location] distanceFromLocation:currentLocation];

                        if (distanceA < distanceB) {
                            return (NSComparisonResult) NSOrderedAscending;
                        }
                        else if (distanceA > distanceB) {
                            return (NSComparisonResult) NSOrderedDescending;
                        }
                        return (NSComparisonResult) NSOrderedSame;

                    }];

                    if (candidates.count > 0) {
                        NSArray *excludedPlaceIds = [conversation.negativeUserFeedback linq_select:^(USuggestionNegativeFeedback *f) {
                            return f.restaurant.placeId;
                        }];

                        NSArray *places = [candidates linq_where:^(Place *p) {
                            return [excludedPlaceIds linq_all:^(NSString *id) {
                                return (BOOL) (![p.placeId isEqualToString:id]);
                            }];
                        }];

                        [subscriber sendNext:[_searchService getRestaurantForPlace:places[0]]];
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