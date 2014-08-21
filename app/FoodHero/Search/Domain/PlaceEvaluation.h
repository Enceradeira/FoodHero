//
// Created by Jorg on 20/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
#import "SearchParameter.h"
extern const double EVAL_MAX_SCORE;
extern const double EVAL_MIN_SCORE;
extern const double EVAL_DISTANCE_DECREMENT_FACTOR;

@interface PlaceEvaluation : NSObject

+ (double)scorePlace:(Place *)place location:(CLLocation *)location preference:(SearchParameter *)preference;

+ (double)scorePlace:(Place *)place distance:(double)distance preference:(SearchParameter *)preference;
@end