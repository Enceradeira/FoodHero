//
// Created by Jorg on 03/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantDetailTableViewController.h"
#import "Restaurant.h"
#import "TyphoonComponents.h"
#import "LocationService.h"
#import "OpeningHoursViewController.h"
#import "FoodHero-Swift.h"


@interface RestaurantDetailTableViewController () <UIPopoverPresentationControllerDelegate>
@end

@implementation RestaurantDetailTableViewController {

    Restaurant *_restaurant;
    LocationService *_locationService;
}

- (void)setLocationService:(LocationService *)locationService {
    _locationService = locationService;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_urlButton imageView].highlightedImage = [UIImage imageNamed:@"world-icon-transparent@2x.png"];
    [_phoneButton imageView].highlightedImage = [UIImage imageNamed:@"phone-receiver-icon-transparent@2x.png"];
    [_mapButton imageView].highlightedImage = [UIImage imageNamed:@"map-icon-transparent@2x.png"];

    [self addTapGesture:self.openingHours handledBy:@selector(openingHoursTouched:)];
    [self addTapGesture:self.phoneNumber handledBy:@selector(phoneNumberTouched:)];
    [self addTapGesture:self.url handledBy:@selector(urlTouched:)];
    [self addTapGesture:self.map handledBy:@selector(mapTouched:)];

    [self bind];
}

- (void)addTapGesture:(UILabel *)view handledBy:(SEL)handler {
    UITapGestureRecognizer *tapGesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:handler];
    [view addGestureRecognizer:tapGesture];
}

- (void)openingHoursTouched:(UITapGestureRecognizer *)sender {
    OpeningHoursViewController *ctrl = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"OpeningHoursViewController"];
    ctrl.modalPresentationStyle = UIModalPresentationPopover;
    ctrl.openingHours = _restaurant.openingHours;

    UIPopoverPresentationController *popoverCtrl = [ctrl popoverPresentationController];
    popoverCtrl.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverCtrl.sourceView = self.openingHours;
    CGRect bounds = self.openingHours.bounds;
    NSInteger margins = 5;
    popoverCtrl.sourceRect = CGRectMake(bounds.origin.x, bounds.origin.y + margins, bounds.size.width, bounds.size.height);
    popoverCtrl.delegate = self;

    [self presentViewController:ctrl animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;

    [self bind];
}

- (void)bind {
    self.name.text = _restaurant.name;
    self.address.text = _restaurant.address;
    self.openingStatus.text = _restaurant.openingStatus;
    if ([_restaurant.openingHoursToday isEqualToString:@""]) {
        self.openingHours.text = @"see opening hours here";
    }
    else {
        self.openingHours.text = _restaurant.openingHoursToday;
    }

    NSString *phoneNumber = _restaurant.phoneNumber;
    self.phoneNumber.text = phoneNumber;
    self.phoneButton.hidden = phoneNumber.length == 0;

    NSString *urlForDisplaying = _restaurant.urlForDisplaying;
    self.url.text = urlForDisplaying;
    self.urlButton.hidden = urlForDisplaying.length == 0;

    RestaurantDistance *distance = _restaurant.distance;
    double meters = distance.distanceFromSearchLocation;
    double miles = meters / 1000 * 0.621;

    NSString *locationDescription = @"away";
    if (distance.hasPreferredSearchLocation) {
        locationDescription = [NSString stringWithFormat:@"from %@", distance.searchLocationDescription];
    }

    if (miles >= 0.2) {
        self.map.text = [NSString stringWithFormat:@"%.1f miles %@", miles, locationDescription];
    }
    else {
        double yards = meters * 1.093613;
        self.map.text = [NSString stringWithFormat:@"%.0f yards %@", yards, locationDescription];
    }

}

- (IBAction)phoneNumberTouched:(UITapGestureRecognizer *)sender {
    NSString *cleanedString = [[_restaurant.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:telURL];
    [self logGAIEvent:@"phone"];
}

- (IBAction)urlTouched:(UITapGestureRecognizer *)sender {
    NSURL *webUrl = [NSURL URLWithString:_restaurant.url];
    [[UIApplication sharedApplication] openURL:webUrl];
    [self logGAIEvent:@"url"];
}

- (IBAction)mapTouched:(UITapGestureRecognizer *)sender {
    RestaurantMapViewController *controller = [[TyphoonComponents storyboard] instantiateViewControllerWithIdentifier:@"RestaurantMapView"];
    [controller setRestaurant:_restaurant];
    [self.navigationController pushViewController:controller animated:YES];
    [self logGAIEvent:@"map"];
}

- (void)logGAIEvent:(NSString *)label {
    [GAIService logEventWithCategory:[GAICategories uIUsage] action:[GAIActions uIUsageRestaurantDetailInput] label:label value:0];
}


@end