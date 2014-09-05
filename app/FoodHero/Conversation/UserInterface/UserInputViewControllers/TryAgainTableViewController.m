//
// Created by Jorg on 13/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TryAgainTableViewController.h"
#import "ConversationTokenTableViewCell.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "UTryAgainNow.h"


@implementation TryAgainTableViewController {

}
- (NSInteger)numberOfRows {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationTokenTableViewCell *cell = (ConversationTokenTableViewCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell setToken:[UTryAgainNow new] accessibilityId:@"TryAgainEntry"];
    return cell;
}

@end