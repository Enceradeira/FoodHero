//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantReviewPageViewController.h"
#import "TyphoonComponents.h"
#import "RestaurantReviewSummaryViewController.h"
#import "RestaurantReviewCommentViewController.h"
#import "IPhoto.h"
#import "RestaurantPhotoViewController.h"


@implementation RestaurantReviewPageViewController {
    Restaurant *_restaurant;
    NSUInteger _index;
    NSArray *_objects;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = self;

    NSArray *controllers = @[[self createSummaryController:_restaurant]];
    [self setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    _index = 0;
}

- (RestaurantReviewSummaryViewController *)createSummaryController:(Restaurant *)restaurant {
    RestaurantReviewSummaryViewController *ctrl = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantReviewSummaryViewController"];
    [ctrl setRestaurant:restaurant];
    return ctrl;
}


- (RestaurantReviewCommentViewController *)createCommentControllerFor:(RestaurantReview *)review {
    RestaurantReviewCommentViewController *ctrl = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantReviewCommentViewController"];
    [ctrl setReview:review];
    return ctrl;
}

- (UIViewController *)createPhotoControllerFor:(id <IPhoto>)photo {
    RestaurantPhotoViewController *ctrl = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantPhotoViewController"];
    [ctrl setPhoto:photo];
    return ctrl;
}


- (UIViewController *)createControllerForObject:(id)object {
    if ([object isKindOfClass:[Restaurant class]]) {
        return [self createSummaryController:object];
    }
    else if ([object isKindOfClass:[RestaurantReview class]]) {
        return [self createCommentControllerFor:object];
    }
    else {
        return [self createPhotoControllerFor:object];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (_index == 0) {
        return nil;
    }

    _index--;
    return [self createControllerForObject:_objects[_index]];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (_index == _objects.count - 1) {
        return nil;
    }

    _index++;
    [self prefetchNextPhoto];
    return [self createControllerForObject:_objects[_index]];
}

- (void)prefetchNextPhoto {
    NSUInteger nextIndex = _index+1;
    if( nextIndex < _objects.count ) {
        id nextObject = _objects[nextIndex];
        if([nextObject conformsToProtocol:@protocol(IPhoto)]){
            [((id<IPhoto>)nextObject) preFetchImage];
        }
    }
}

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;
    NSMutableArray *objects = [NSMutableArray new];
    // summary & first photo
    [objects addObject:restaurant];
    // reviews
    for (RestaurantReview *review in restaurant.rating.reviews) {
        [objects addObject:review];
    }
    // second or later photos
    for (id <IPhoto> photo in [_restaurant.photos linq_skip:1]) {
        [objects addObject:photo];
    }
    _objects = objects;
}

/*
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    if (!_rating.summary) {
        return 0;
    }
    else {
        return _rating.reviews.count + 1;
    }
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
} */


@end