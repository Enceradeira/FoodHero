//
//  RestaurantPhotoViewControllerTests.m
//  FoodHero
//
//  Created by Jorg on 07/11/14.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest.h>
#import "ControllerFactory.h"
#import "StubAssembly.h"
#import "TyphoonComponents.h"
#import "RestaurantReviewSummaryViewController.h"
#import "RestaurantPhotoViewController.h"
#import "PhotoBuilder.h"

@interface RestaurantPhotoViewControllerTests : XCTestCase

@end

@implementation RestaurantPhotoViewControllerTests {

    RestaurantPhotoViewController *_ctrl;
    id <IPhoto> _photo;
    UIImage *_image;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly assembly]];
    _ctrl = [ControllerFactory createRestaurantPhotoViewController];
    _ctrl.view.hidden = NO;

    _image = [UIImage new];
    _photo = [[[PhotoBuilder alloc] withImage:_image] build];
    [_ctrl setPhoto:_photo];
}

- (void)test_imageView_ShouldContainImage {
    assertThat(_ctrl.imageView.image, is(equalTo(_image)));
}

@end
