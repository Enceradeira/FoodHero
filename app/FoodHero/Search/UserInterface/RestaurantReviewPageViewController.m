//
// Created by Jorg on 30/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "TyphoonComponents.h"
#import "RestaurantReviewSummaryViewController.h"
#import "RestaurantReviewCommentViewController.h"
#import "IPhoto.h"
#import "RestaurantPhotoViewController.h"
#import "ControllerFactory.h"


@implementation RestaurantReviewPageViewController {
    Restaurant *_restaurant;
    NSUInteger _index;
    NSArray *_objects;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = self;

    UIViewController <INotebookPageHostViewController> *summaryController = [self createSummaryController:_restaurant];
    [summaryController embedNotebookWith:NotebookPageModeSmall];

    NSArray *controllers = @[summaryController];
    [self setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    _index = 0;
}

- (UIViewController <INotebookPageHostViewController> *)createSummaryController:(Restaurant *)restaurant {
    RestaurantReviewSummaryViewController *ctrl = [ControllerFactory createRestaurantReviewSummaryViewController];
    [ctrl setRestaurant:restaurant];
    return ctrl;
}


- (UIViewController <INotebookPageHostViewController> *)createCommentControllerFor:(RestaurantReview *)review {
    RestaurantReviewCommentViewController *ctrl = [ControllerFactory createRestaurantReviewCommentViewController];
    [ctrl setReview:review];
    return ctrl;
}

- (UIViewController <INotebookPageHostViewController> *)createPhotoControllerFor:(id <IPhoto>)photo {
    RestaurantPhotoViewController *ctrl = [ControllerFactory createRestaurantPhotoViewController];
    [ctrl setPhoto:photo];
    return ctrl;
}


- (UIViewController <INotebookPageHostViewController> *)createControllerForObject:(id)object mode:(NotebookPageMode)mode {
    UIViewController <INotebookPageHostViewController> *ctrl;
    if ([object isKindOfClass:[Restaurant class]]) {
        ctrl = [self createSummaryController:object];
    }
    else if ([object isKindOfClass:[RestaurantReview class]]) {
        ctrl = [self createCommentControllerFor:object];
    }
    else {
        ctrl = [self createPhotoControllerFor:object];
    }
    [ctrl embedNotebookWith:mode];
    return ctrl;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (_index == 0) {
        return nil;
    }

    _index--;
    return [self createControllerForObject:_objects[_index] mode:NotebookPageModeSmall];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (_index == _objects.count - 1) {
        return nil;
    }

    _index++;
    [self prefetchNextPhoto];
    return [self createControllerForObject:_objects[_index] mode:NotebookPageModeSmall];
}

- (void)prefetchNextPhoto {
    NSUInteger nextIndex = _index + 1;
    if (nextIndex < _objects.count) {
        id nextObject = _objects[nextIndex];
        if ([nextObject conformsToProtocol:@protocol(IPhoto)]) {
            [((id <IPhoto>) nextObject) preFetchImage];
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

- (UIViewController <INotebookPageHostViewController> *)createCloneOfCurrentlyVisibleControllerForEnlargedView {
    return [self createControllerForObject:_objects[_index] mode:NotebookPageModeLarge];
}
@end