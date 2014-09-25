//
// Created by Jorg on 13/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TryAgainTableViewController.h"
#import "ConversationTokenTableViewCell.h"
#import "UDidResolveProblemWithAccessLocationService.h"
#import "UTryAgainNow.h"
#import "UWantsToAbort.h"


@implementation TryAgainTableViewController {

}
- (NSInteger)numberOfRows {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationTokenTableViewCell *cell = (ConversationTokenTableViewCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if( indexPath.row == 0) {
        [cell setToken:[UTryAgainNow new] accessibilityId:@"TryAgainEntry"];
    }
    else{
        [cell setToken:[UWantsToAbort new] accessibilityId:@"AbortEntry"];
    }
    return cell;
}

@end