//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForTooFarAway.h"
#import "DesignByContractException.h"


@implementation USuggestionFeedbackForTooFarAway {

}

+ (instancetype)create:(Restaurant *)restaurant currentUserLocation:(CLLocation *)location text:(NSString *)text {
    return [[USuggestionFeedbackForTooFarAway alloc] initWithRestaurant:restaurant text:text currentUserLocation:location];
}

- (id)initWithRestaurant:(Restaurant *)restaurant text:(NSString *)text currentUserLocation:(CLLocation *)location {
    self = [super initWithRestaurant:restaurant text:text type:@"tooFarAway"];
    if (self != nil) {
        if( location == nil){
            @throw [DesignByContractException createWithReason:@"location can't be nil"];
        }
        _currentUserLocation = location;
    }
    return self;
}

+ (TalkerUtterance*)createUtterance:(Restaurant *)restaurant currentUserLocation:(CLLocation *)location text:(NSString *)text  {
    USuggestionFeedbackParameters *parameters = [[USuggestionFeedbackParameters alloc] initWithSemanticId:@"U:SuggestionFeedback=tooFarAway" restaurant:restaurant currentUserLocation:location];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}

@end