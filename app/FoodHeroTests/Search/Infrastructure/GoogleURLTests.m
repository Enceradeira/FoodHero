//
//  GoogleURLTests.m
//  FoodHero
//
//  Created by Jorg on 16/10/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.H>
#import "GoogleURL.h"

@interface GoogleURLTests : XCTestCase

@end

@implementation GoogleURLTests

- (NSString *)userFriendlyURL:(NSString *)url {
    return [GoogleURL create:url].userFriendlyURL;
}


- (void)test_userFriendlyURL_ShouldDoNothing_WhenStringIsNotURL {
    assertThat([self userFriendlyURL:@""], is(equalTo(@"")));
    assertThat([self userFriendlyURL:@"http"], is(equalTo(@"http")));
    assertThat([self userFriendlyURL:@"ffdhttp:/"], is(equalTo(@"ffdhttp:/")));
    assertThat([self userFriendlyURL:@"ww.jennius.co.uk"], is(equalTo(@"ww.jennius.co.uk")));
}

- (void)test_userFriendlyURL_ShouldRemoveHTTP {
    assertThat([self userFriendlyURL:@"http://jennius.co.uk"], is(equalTo(@"jennius.co.uk")));
    assertThat([self userFriendlyURL:@"http://jennius.co.uk/index.html"], is(equalTo(@"jennius.co.uk/index.html")));
}

- (void)test_userFriendlyURL_ShouldRemoveWWW {
    assertThat([self userFriendlyURL:@"http://www.jennius.co.uk"], is(equalTo(@"jennius.co.uk")));
}

- (void)test_userFriendlyURL_ShouldRemoveEmptyPath {
    assertThat([self userFriendlyURL:@"http://jennius.co.uk/"], is(equalTo(@"jennius.co.uk")));
}

- (void)test_userFriendlyURL_ShouldDoNothing_WhenPathIsNotEmpty {
    assertThat([self userFriendlyURL:@"jennius.co.uk/index.html"], is(equalTo(@"jennius.co.uk/index.html")));
}


- (void)test_userFriendlyURL_ShouldNotRemoveHTTPS {
    assertThat([self userFriendlyURL:@"https://jennius.co.uk"], is(equalTo(@"https://jennius.co.uk")));
    assertThat([self userFriendlyURL:@"https://jennius.co.uk/"], is(equalTo(@"https://jennius.co.uk/")));
    assertThat([self userFriendlyURL:@"https://jennius.co.uk/index.html"], is(equalTo(@"https://jennius.co.uk/index.html")));
}

@end
