//
// Created by Jorg on 10/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "WhatToDoNextTableViewController.h"
#import "ConversationViewStateListOnlyInput.h"
#import "DesignByContractException.h"
#import "UGoodBye.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "ConversationTokenTableViewCell.h"


@implementation WhatToDoNextTableViewController {

    UGoodBye *_goodByAnswer;
    UWantsToSearchForAnotherRestaurant *_searchAgainAnswer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _goodByAnswer = [UGoodBye new];
    _searchAgainAnswer = [UWantsToSearchForAnotherRestaurant new];
}

- (NSInteger)numberOfRows {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationTokenTableViewCell *cell = (ConversationTokenTableViewCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell setToken:_goodByAnswer accessibilityId:@"GoodByeEntry"];
    }
    else {
        [cell setToken:_searchAgainAnswer accessibilityId:@"SearchForAnotherRestaurantEntry"];
    }
    return cell;
}

@end