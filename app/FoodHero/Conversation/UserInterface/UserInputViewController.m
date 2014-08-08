//
//  UserInputViewController.m
//  FoodHero
//
//  Created by Jorg on 08/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UserInputViewController.h"

@implementation UserInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // self.currentSegueIdentifier = SegueIdentifierFirst;
    //[self performSegueWithIdentifier:@"embedCuisineView" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self addChildViewController:segue.destinationViewController];
    ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
    [segue.destinationViewController didMoveToParentViewController:self];

    /*
    if ([segue.identifier isEqualToString:SegueIdentifierFirst])
    {
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:segue.destinationViewController];
        }
        else {
            [self addChildViewController:segue.destinationViewController];
            ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    else if ([segue.identifier isEqualToString:SegueIdentifierSecond])
    {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:segue.destinationViewController];
    } */
}

@end
