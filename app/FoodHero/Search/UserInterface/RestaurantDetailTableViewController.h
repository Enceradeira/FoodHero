//
// Created by Jorg on 03/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantController.h"

@class LocationService;


@interface RestaurantDetailTableViewController : UITableViewController<RestaurantController>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *openingStatus;
@property (weak, nonatomic) IBOutlet UILabel *openingHours;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *url;
@property (weak, nonatomic) IBOutlet UILabel *directions;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

- (void)setLocationService:(LocationService *)locationService;

- (void)openingHoursTouched:(id)sender;

- (IBAction)phoneNumberTouched:(id)sender;
- (IBAction)urlTouched:(id)sender;
- (IBAction)directionsTouched:(id)sender;
@end