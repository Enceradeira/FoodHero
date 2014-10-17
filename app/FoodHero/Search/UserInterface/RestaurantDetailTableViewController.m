//
// Created by Jorg on 03/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantDetailTableViewController.h"
#import "Restaurant.h"


@implementation RestaurantDetailTableViewController {

    Restaurant *_restaurant;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Restaurant-Detail-Content-Background.png"]];
    imageView.contentMode = UIViewContentModeBottom;
    self.tableView.backgroundView = imageView;

    [self bind];
}

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;

    [self bind];
}

- (void)bind {
    self.name.text = _restaurant.name;
    self.address.text = _restaurant.address;
    self.openingStatus.text = _restaurant.openingStatus;
    self.openingHours.text = _restaurant.openingHours;
    self.phoneNumber.text = _restaurant.phoneNumber;
    self.url.text = _restaurant.url;
}

@end