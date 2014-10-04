//
// Created by Jorg on 03/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantReviewTableViewController.h"


@implementation RestaurantReviewTableViewController {

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    if (indexPath.row == 0) {
        identifier = @"Rating";
    }
    else if (indexPath.row == 1) {
        identifier = @"Summary";
    }
    else {
        identifier = @"Comment";
    }

    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

@end