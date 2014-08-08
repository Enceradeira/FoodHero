//
//  CuisineTableViewController.h
//  FoodHero
//
//  Created by Jorg on 08/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UserInputViewSubscriber.h"

@interface CuisineTableViewController : UITableViewController

- (void)setDelegate:(id <UserInputViewSubscriber>)delegate;
@end
