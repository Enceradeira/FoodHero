//
//  PriceLevelRangeTests.m
//  FoodHero
//
//  Created by Jorg on 16/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//


#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "PriceLevelRange.h"
#import "HCIsExceptionOfType.h"
#import "DesignByContractException.h"

@interface PriceLevelRangeTests : XCTestCase

@end

@implementation PriceLevelRangeTests

- (void)test_isEqual_ShouldBeYes_WhenEqualValues {
    assertThat([PriceLevelRange createFullRange], is(equalTo([PriceLevelRange createFullRange])));
}

- (void)test_isEqual_ShouldBeNo_WhenPriceLevelIsDifferent {
    // change max
    assertThat([PriceLevelRange createFullRange], isNot(equalTo([[PriceLevelRange createFullRange] setMaxLowerThan:2])));
    // change min
    assertThat([PriceLevelRange createFullRange], isNot(equalTo([[PriceLevelRange createFullRange] setMinHigherThan:3])));
}

- (void)test_createFullRange_ShouldInitializeRangeCorrectly {
    PriceLevelRange *range = [PriceLevelRange createFullRange];
    assertThatUnsignedInt(range.max, is(equalTo(@(GOOGLE_PRICE_LEVEL_MAX))));
    assertThatUnsignedInt(range.min, is(equalTo(@(GOOGLE_PRICE_LEVEL_MIN))));
}

- (void)test_setMinHigherThan_ShouldSetNewMinimun {
    PriceLevelRange *range = [PriceLevelRange createFullRange];
    range = [range setMinHigherThan:2];
    assertThatInteger(range.min, is(equalTo(@3)));
}

- (void)test_setMinHigherThan_ShouldThrowException_WhenMinIsSetToHigherValueThanMaxium {
    PriceLevelRange *range = [PriceLevelRange createFullRange];

    assertThat(^() {
        [range setMinHigherThan:GOOGLE_PRICE_LEVEL_MAX];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_setMinHigherThan_ShouldPushUpMaximum_WhenMinimumBecomesGreaterThanMaximum {
    PriceLevelRange *range = [PriceLevelRange createFullRange];

    range = [range setMaxLowerThan:2];  // set max to 1
    range = [range setMinHigherThan:2]; // set min to 3

    assertThatUnsignedInt(range.min, is(equalTo(@3)));
    assertThatUnsignedInt(range.max, is(equalTo(@3)));
}

- (void)test_setMinHigherThan_ShouldNotPushUpMaximum_WhenMinimumDoesntBecomeGreaterThanMaximum {
    PriceLevelRange *range = [PriceLevelRange createFullRange];

    range = [range setMaxLowerThan:4];  // set max to 3
    range = [range setMinHigherThan:2]; // set min to 3

    assertThatUnsignedInt(range.min, is(equalTo(@3)));
    assertThatUnsignedInt(range.max, is(equalTo(@3)));
}

- (void)test_setMaxLowerThan_ShouldDecreaseMaximum {
    PriceLevelRange *range = [PriceLevelRange createFullRange];
    range = [range setMaxLowerThan:2];
    assertThatInteger(range.max, is(equalTo(@1)));
}

- (void)test_setMaxLowerThan_ShouldThrowException_WhenMaxIsSetToLowerValueThanMinimun {
    PriceLevelRange *range = [PriceLevelRange createFullRange];

    assertThat(^() {
        [range setMaxLowerThan:GOOGLE_PRICE_LEVEL_MIN];
    }, throwsExceptionOfType([DesignByContractException class]));
}

- (void)test_setMaxLowerThan_ShouldPushDownMinimum_WhenMaximumBecomesSmallerThanMinium {
    PriceLevelRange *range = [PriceLevelRange createFullRange];

    range = [range setMinHigherThan:2]; // set min to 3
    range = [range setMaxLowerThan:2];  // set max to 1

    assertThatUnsignedInt(range.min, is(equalTo(@1)));
    assertThatUnsignedInt(range.max, is(equalTo(@1)));
}

- (void)test_setMaxLowerThan_ShouldNotPushDownMinimum_WhenMaximumDoesntBecomeSmallerThanMinium {
    PriceLevelRange *range = [PriceLevelRange createFullRange];

    range = [range setMinHigherThan:2]; // set min to 3
    range = [range setMaxLowerThan:4];  // set max to 3

    assertThatUnsignedInt(range.min, is(equalTo(@3)));
    assertThatUnsignedInt(range.max, is(equalTo(@3)));
}

@end
