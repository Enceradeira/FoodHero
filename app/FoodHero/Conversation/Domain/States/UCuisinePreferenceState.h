//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "ActionFeedbackTarget.h"
#import "RestaurantSearch.h"
#import "AtomicSymbol.h"

@interface UCuisinePreferenceState : AtomicSymbol

+ (UCuisinePreferenceState *)createWithActionFeedback:(id <ActionFeedbackTarget>)actionFeedback restaurantSearch:(RestaurantSearch *)restaurantSearch;
@end