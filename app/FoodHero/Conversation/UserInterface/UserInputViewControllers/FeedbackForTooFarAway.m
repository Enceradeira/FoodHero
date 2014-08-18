//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FeedbackForTooFarAway.h"
#import "LocationService.h"
#import "USuggestionFeedbackForTooFarAway.h"


@implementation FeedbackForTooFarAway {

    LocationService *_locationService;
}

+ (instancetype)create:(UIImage *)image choiceText:(NSString *)choiceText locationService:(LocationService *)locationService {
    return [[FeedbackForTooFarAway alloc] initWithImage:image choiceText:choiceText locationService:locationService];
}

- (id)initWithImage:(UIImage *)image choiceText:(NSString *)choiceText locationService:(LocationService *)locationService {
    self = [super initWithTokenClass:[USuggestionFeedbackForTooFarAway class] image:image choiceText:choiceText];
    if (self != nil) {
        _locationService = locationService;
    }
    return self;
}

- (ConversationToken *)createTokenFor:(Restaurant *)restaurant {
    return [USuggestionFeedbackForTooFarAway create:restaurant currentUserLocation:_locationService.lastKnownLocation];
}

@end