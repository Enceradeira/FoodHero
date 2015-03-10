//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForNotLikingAtAll.h"


@implementation USuggestionFeedbackForNotLikingAtAll {

}

+ (instancetype)create:(Restaurant *)restaurant text:(NSString *)text {
    return [[USuggestionFeedbackForNotLikingAtAll alloc] initWithRestaurant:restaurant text:text type:@"Dislike"];
}

+ (TalkerUtterance*)createUtterance:(Restaurant *)restaurant currentUserLocation:(CLLocation *)location text:(NSString *)text  {
    USuggestionFeedbackParameters *parameters = [[USuggestionFeedbackParameters alloc] initWithSemanticId:@"U:SuggestionFeedback=Dislike" restaurant:restaurant currentUserLocation:location];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}

@end