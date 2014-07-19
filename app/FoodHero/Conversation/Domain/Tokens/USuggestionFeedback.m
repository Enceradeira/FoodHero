//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedback.h"


@implementation USuggestionFeedback {
}
+ (instancetype)createForRestaurant:(Restaurant *)restaurant parameter:(NSString *)parameter{
    return [[USuggestionFeedback alloc] initWithRestaurant:restaurant parameter:parameter];
}

- (instancetype)initWithRestaurant:(Restaurant *)restaurant parameter:(NSString *)parameter {
    self = [super initWithParameter:@"U:SuggestionFeedback" parameter:parameter];
    if(self != nil){
        _restaurant = restaurant;
    }
    return self;
}
@end