//
//  GooglePhotoTests.m
//  FoodHero
//
//  Created by Jorg on 07/11/14.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ReactiveCocoa.h>
#import <OCHamcrest/OCHamcrest.h>
#import <XCTestCase+AsyncTesting.h>
#import "GooglePhoto.h"

@interface GooglePhotoTests : XCTestCase

@end

@implementation GooglePhotoTests {
    NSString *_reference;
    NSUInteger _width;
    NSUInteger _heigth;
}

- (void)setUp {
    [super setUp];

    _reference = @"CnRnAAAAUA_43WDiFBmoEJbbWUfrWXxAFBFvseFfLsZ4JT-1w6obr2wuQ96Bq2101QAOnMiqVZqT6KRMLibNNXGggke2SMWaqCGWK20oB9IB0T4heE8BiESBiEaMkpkPQQY34gWEksKy9c64HHx3ilint1QuWxIQ5aX2wUuY-exEKj4DFU8_YhoUfBx8VFU0opdr8v-EQ2U2wLTtkFk";
    _width = 774;
    _heigth = 665;

}

- (void)assertThatImageCanBeResubscribedWhenLoadedEagerly:(BOOL)loadEagerly {
    GooglePhoto *photo = [GooglePhoto create:_reference height:_heigth width:_width loadEagerly:loadEagerly];

    NSArray *photos1 = [photo.image toArray];
    NSArray *photos2 = [photo.image toArray];

    assertThatInteger(photos1.count, is(greaterThan(@(0))));
    assertThatInteger(photos2.count, is(greaterThan(@(0))));
    assertThat(photos1[0], is(equalTo(photos2[0])));
}


- (void)assertImageLoadedWhenLoadEagerly:(BOOL)loadEagerly {
    __block UIImage *loadedImage;

    GooglePhoto *photo = [GooglePhoto create:_reference height:_heigth width:_width loadEagerly:loadEagerly];

    RACSignal *imageSignal = photo.image;
    [imageSignal subscribeNext:^(UIImage *image) {
        loadedImage = image;
    }];

    [imageSignal subscribeCompleted:^() {
        [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    }];

    [imageSignal subscribeError:^(NSError *e) {
        [self XCA_notify:XCTAsyncTestCaseStatusFailed];
    }];

    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];
    assertThat(loadedImage, is(notNilValue()));
}


- (void)test_image_ShouldReturnLoadedImage_WhenEagerlyLoaded {
    [self assertImageLoadedWhenLoadEagerly:YES];
}

- (void)test_image_ShouldReturnLoadedImage_WhenNotEagerlyLoaded {
    [self assertImageLoadedWhenLoadEagerly:NO];

}

- (void)test_image_ShouldSendError_WhenImageCannotBeLoaded {
    GooglePhoto *photo = [GooglePhoto create:@"rummy kummy doesn't exist" height:_heigth width:_width loadEagerly:NO];

    RACSignal *imageSignal = photo.image;
    [imageSignal subscribeError:^(NSError *e) {
        [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    }];
    [imageSignal subscribeCompleted:^() {
        [self XCA_notify:XCTAsyncTestCaseStatusFailed];
    }];

    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];
}

- (void)test_image_CanBeResubscribed_WhenNotEagerlyLoaded {
    [self assertThatImageCanBeResubscribedWhenLoadedEagerly:NO];

}

- (void)test_image_CanBeResubscribed_WhenEagerlyLoaded {
    [self assertThatImageCanBeResubscribedWhenLoadedEagerly:YES];

}
@end
