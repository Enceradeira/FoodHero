//
//  PriceRangeTests.m
//  FoodHero
//
//  Created by Jorg on 16/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "PriceRange.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"

@interface PriceRangeTests : XCTestCase

@end

@implementation PriceRangeTests

- (void)test_isEqual_ShouldBeYes_WhenEqualValues {
    assertThat([PriceRange priceRangeWithoutRestriction], is(equalTo([PriceRange priceRangeWithoutRestriction])));
}

- (void)test_isEqual_ShouldBeNo_WhenPriceLevelIsDifferent {
    // change max
    assertThat([PriceRange priceRangeWithoutRestriction], isNot(equalTo([[PriceRange priceRangeWithoutRestriction] setMaxLowerThan:2])));
    // change min
    assertThat([PriceRange priceRangeWithoutRestriction], isNot(equalTo([[PriceRange priceRangeWithoutRestriction] setMinHigherThan:3])));
}

- (void)test_createFullRange_ShouldInitializeRangeCorrectly {
    PriceRange *range = [PriceRange priceRangeWithoutRestriction];
    assertThatUnsignedInt(range.max, is(equalTo(@(GOOGLE_PRICE_LEVEL_MAX))));
    assertThatUnsignedInt(range.min, is(equalTo(@(GOOGLE_PRICE_LEVEL_MIN))));
}

- (void)test_setMinHigherThan_ShouldSetNewMinimun {
    PriceRange *range = [PriceRange priceRangeWithoutRestriction];
    range = [range setMinHigherThan:2];
    assertThatInteger(range.min, is(equalTo(@3)));
}

- (void)test_setMinHigherThan_ShouldThrowException_WhenMinIsSetToHigherValueThanMaxium {
    PriceRange *range = [PriceRange priceRangeWithoutRestriction];

    assertThat(^() {
        [range setMinHigherThan:GOOGLE_PRICE_LEVEL_MAX];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_setMinHigherThan_ShouldPushUpMaximum_WhenMinimumBecomesGreaterThanMaximum {
    PriceRange *range = [PriceRange priceRangeWithoutRestriction];

    range = [range setMaxLowerThan:2];  // set max to 1
    range = [range setMinHigherThan:2]; // set min to 3

    assertThatUnsignedInt(range.min, is(equalTo(@3)));
    assertThatUnsignedInt(range.max, is(equalTo(@3)));
}

- (void)test_setMinHigherThan_ShouldNotPushUpMaximum_WhenMinimumDoesntBecomeGreaterThanMaximum {
    PriceRange *range = [PriceRange priceRangeWithoutRestriction];

    range = [range setMaxLowerThan:4];  // set max to 3
    range = [range setMinHigherThan:2]; // set min to 3

    assertThatUnsignedInt(range.min, is(equalTo(@3)));
    assertThatUnsignedInt(range.max, is(equalTo(@3)));
}

- (void)test_setMaxLowerThan_ShouldDecreaseMaximum {
    PriceRange *range = [PriceRange priceRangeWithoutRestriction];
    range = [range setMaxLowerThan:2];
    assertThatInteger(range.max, is(equalTo(@1)));
}

- (void)test_setMaxLowerThan_ShouldThrowException_WhenMaxIsSetToLowerValueThanMinimun {
    PriceRange *range = [PriceRange priceRangeWithoutRestriction];

    assertThat(^() {
        [range setMaxLowerThan:GOOGLE_PRICE_LEVEL_MIN];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_setMaxLowerThan_ShouldPushDownMinimum_WhenMaximumBecomesSmallerThanMinium {
    PriceRange *range = [PriceRange priceRangeWithoutRestriction];

    range = [range setMinHigherThan:2]; // set min to 3
    range = [range setMaxLowerThan:2];  // set max to 1

    assertThatUnsignedInt(range.min, is(equalTo(@1)));
    assertThatUnsignedInt(range.max, is(equalTo(@1)));
}

- (void)test_setMaxLowerThan_ShouldNotPushDownMinimum_WhenMaximumDoesntBecomeSmallerThanMinium {
    PriceRange *range = [PriceRange priceRangeWithoutRestriction];

    range = [range setMinHigherThan:2]; // set min to 3
    range = [range setMaxLowerThan:4];  // set max to 3

    assertThatUnsignedInt(range.min, is(equalTo(@3)));
    assertThatUnsignedInt(range.max, is(equalTo(@3)));
}

@end
