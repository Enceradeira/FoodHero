//
// Created by Jorg on 15/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RadiusCalculator.h"
#import "GoogleRestaurantSearch.h"
#import "DesignByContractException.h"


@implementation RadiusCalculator {

}
+ (NSArray *)doUntilRightNrOfElementsReturned:(NSArray *(^)(double))elementFactory {
    NSArray *result;
    double radius = GOOGLE_MAX_SEARCH_RADIUS / 2;
    double radiusDelta = GOOGLE_MAX_SEARCH_RADIUS / 4;

    // implements a binary search starting in the middle of the search range defined by GOOGLE_MAX_SEARCH_RADIUS
    BOOL searchAgain;
    do {
        NSLog([NSString stringWithFormat:@"Radius: %f ", radius]);
        result = elementFactory(radius);
        if (result == nil) {
            @throw [DesignByContractException createWithReason:@"elementFactory returned nil"];
        }

        if (result.count >= GOOGLE_MAX_SEARCH_RESULTS) {
            radius -= radiusDelta;
        }
        else {
            radius += radiusDelta;
        }

        searchAgain = [self anotherSearchIsRequiredForElementCount:result.count radiusDelta:radiusDelta];
        radiusDelta /= 2;
    } while (searchAgain);
    return result;
}

+ (BOOL)anotherSearchIsRequiredForElementCount:(NSUInteger)count radiusDelta:(double)delta {
    BOOL countIsNotGood = count >= GOOGLE_MAX_SEARCH_RESULTS || count < (GOOGLE_MAX_SEARCH_RESULTS * 0.5);
    BOOL makeSenseToChangeRadius = delta > 500;
    return countIsNotGood && makeSenseToChangeRadius;
}


@end