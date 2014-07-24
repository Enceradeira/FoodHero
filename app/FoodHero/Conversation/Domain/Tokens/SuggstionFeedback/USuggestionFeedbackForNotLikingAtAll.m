//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedbackForNotLikingAtAll.h"


@implementation USuggestionFeedbackForNotLikingAtAll {

}

+ (instancetype)create:(Restaurant *)restaurant {
    return [[USuggestionFeedbackForNotLikingAtAll alloc] initWithRestaurant:restaurant parameter:@"I don't like that restaurant!"];
}

@end