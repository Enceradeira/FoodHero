//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USuggestionNegativeFeedback.h"


@interface USuggestionFeedbackForTooFarAway : USuggestionNegativeFeedback
@property(nonatomic, readonly) CLLocation *currentUserLocation;

+ (instancetype)create:(Restaurant *)restaurant currentUserLocation:(CLLocation *)location text:(NSString *)text;

- (id)initWithRestaurant:(Restaurant *)restaurant text:(NSString *)text currentUserLocation:(CLLocation *)location;
@end