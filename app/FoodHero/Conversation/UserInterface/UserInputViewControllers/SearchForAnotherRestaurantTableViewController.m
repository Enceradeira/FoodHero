//
// Created by Jorg on 13/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SearchForAnotherRestaurantTableViewController.h"
#import "ConversationTokenTableViewCell.h"
#import "UWantsToSearchForAnotherRestaurant.h"


@implementation SearchForAnotherRestaurantTableViewController {

}
- (NSInteger)numberOfRows {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationTokenTableViewCell *cell = (ConversationTokenTableViewCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell setToken:[UWantsToSearchForAnotherRestaurant new] accessibilityId:@"SearchForAnotherRestaurantEntry"];
    return cell;
}

@end