//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForLiking.h"


@implementation USuggestionFeedbackForLiking {

}

+ (instancetype)create:(Restaurant *)restaurant {
    return [[USuggestionFeedbackForLiking alloc] initWithRestaurant:restaurant parameter:@"I like it!"];
}

@end