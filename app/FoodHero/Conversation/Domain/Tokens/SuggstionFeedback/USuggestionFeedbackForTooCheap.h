//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USuggestionNegativeFeedback.h"
#import "FoodHero-Swift.h"


@interface USuggestionFeedbackForTooCheap : USuggestionNegativeFeedback
+ (instancetype)create:(Restaurant *)restaurant text:(NSString *)text;

+ (TalkerUtterance *)createUtterance:(Restaurant *)restaurant currentUserLocation:(CLLocation *)location text:(NSString *)text;
@end