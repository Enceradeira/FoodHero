//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForTooFarAway.h"


@implementation USuggestionFeedbackForTooFarAway {

}

+ (instancetype)create:(Restaurant *)restaurant {
    return [[USuggestionFeedbackForTooFarAway alloc] initWithRestaurant:restaurant parameter:@"It's too far away"];
}

@end