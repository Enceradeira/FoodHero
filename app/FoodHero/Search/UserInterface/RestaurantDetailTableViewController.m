//
// Created by Jorg on 03/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RestaurantDetailTableViewController.h"
#import "Restaurant.h"
#import "TyphoonComponents.h"
#import "LocationService.h"
#import "KeywordEncoder.h"
#import "OpeningHoursViewController.h"


@interface RestaurantDetailTableViewController () <UIPopoverPresentationControllerDelegate>
@end

@implementation RestaurantDetailTableViewController {

    Restaurant *_restaurant;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Restaurant-Detail-Content-Background.png"]];
    imageView.contentMode = UIViewContentModeBottom;
    self.tableView.backgroundView = imageView;

    [_urlButton imageView].highlightedImage = [UIImage imageNamed:@"world-icon-transparent@2x.png"];
    [_phoneButton imageView].highlightedImage = [UIImage imageNamed:@"phone-receiver-icon-transparent@2x.png"];
    [_directionsButton imageView].highlightedImage = [UIImage imageNamed:@"directions-icon-transparent@2x.png"];

    [self addTapGesture:self.openingHours handledBy:@selector(openingHoursTouched:)];
    [self addTapGesture:self.phoneNumber handledBy:@selector(phoneNumberTouched:)];
    [self addTapGesture:self.url handledBy:@selector(urlTouched:)];
    [self addTapGesture:self.directions handledBy:@selector(directionsTouched:)];

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
    self.openingHours.text = _restaurant.openingHoursToday;
    self.phoneNumber.text = _restaurant.phoneNumber;
    self.url.text = _restaurant.urlForDisplaying;
    double meters = _restaurant.distance;
    double miles = meters / 1000 * 0.621;
    if( miles >= 0.2){
        self.directions.text = [NSString stringWithFormat:@"%.1f miles away",miles];
    }
    else{
        double yards = meters * 1.093613;
        self.directions.text = [NSString stringWithFormat:@"%.0f yards away",yards];
    }

}

- (IBAction)phoneNumberTouched:(UITapGestureRecognizer *)sender {
    NSString *cleanedString = [[_restaurant.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:telURL];
}

- (IBAction)urlTouched:(UITapGestureRecognizer *)sender {
    NSURL *webUrl = [NSURL URLWithString:_restaurant.url];
    [[UIApplication sharedApplication] openURL:webUrl];
}

- (IBAction)directionsTouched:(UITapGestureRecognizer *)sender {
    LocationService *locationService = [(id <ApplicationAssembly>) [TyphoonComponents factory] locationService];
    CLLocationCoordinate2D coordinate = locationService.lastKnownLocation.coordinate;

    NSArray *encodedComponents = [_restaurant.addressComponents linq_select:^(NSString *component) {
        return [KeywordEncoder encodeString:component];
    }];
    NSString *restaurantAddressEncoded = [encodedComponents componentsJoinedByString:@","];

    NSString *url = [NSString stringWithFormat:@"https://www.google.com/maps/dir/%f,%f/%@", coordinate.latitude, coordinate.longitude, restaurantAddressEncoded];
    NSURL *webUrl = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:webUrl];
}
@end