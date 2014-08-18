//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feedback.h"

@class LocationService;


@interface FeedbackForTooFarAway : Feedback
+ (instancetype)create:(UIImage *)image choiceText:(NSString *)choiceText locationService:(LocationService *)locationService;

- (instancetype)initWithImage:(UIImage *)image choiceText:(NSString *)text locationService:(LocationService *)service;
@end