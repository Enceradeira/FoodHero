//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForTooExpensive.h"

@implementation USuggestionFeedbackForTooExpensive {

}

+ (instancetype)create:(Restaurant *)restaurant text:(NSString *)text {
    return [[USuggestionFeedbackForTooExpensive alloc] initWithRestaurant:restaurant text:text type:@"tooExpensive"];
}

+ (TalkerUtterance*)createUtterance:(Restaurant *)restaurant currentUserLocation:(CLLocation *)location text:(NSString *)text  {
    USuggestionFeedbackParameters *parameters = [[USuggestionFeedbackParameters alloc] initWithSemanticId:@"U:SuggestionFeedback=tooExpensive" restaurant:restaurant currentUserLocation:location];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:parameters];
}

@end