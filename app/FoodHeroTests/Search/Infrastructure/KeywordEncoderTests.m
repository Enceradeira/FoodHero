//
//  KeywordEncoderTests.m
//  FoodHero
//
//  Created by Jorg on 12/09/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import "KeywordEncoder.h"

@interface KeywordEncoderTests : XCTestCase

@end

@implementation KeywordEncoderTests


- (void)test_encodeString_ShouldEncodeSpaces {
    assertThat([KeywordEncoder encodeString:@"Asian Food"], is(equalTo(@"Asian%20Food")));
}

- (void)test_encodeString_ShouldEncodeAnds {
    assertThat([KeywordEncoder encodeString:@"Fish&Chips"], is(equalTo(@"Fish%26Chips")));
}

@end
