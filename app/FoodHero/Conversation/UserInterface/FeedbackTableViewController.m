//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FeedbackTableViewController.h"
#import "FeedbackTableViewCell.h"
#import "ConversationViewStateListOrTextInput.h"
#import "ConversationViewStateListOnlyInput.h"
#import "DesignByContractException.h"


@implementation FeedbackTableViewController

- (NSInteger)numberOfRows {
    return [self.appService getFeedbackCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCuisineTableViewCell:tableView indexPath:indexPath];
}

- (UITableViewCell *)getCuisineTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feedback" forIndexPath:indexPath];
    cell.feedback = [self.appService getFeedback:(NSUInteger) indexPath.row];
    return cell;
}

- (void)sendUserInput {
    if (self.selectedCell == nil) {
        @throw [DesignByContractException createWithReason:@"method should not be called without a cell beeing selected first"];
    }

    [self.appService addUserFeedbackForLastSuggestedRestaurant:((FeedbackTableViewCell *) self.selectedCell).feedback];
}

@end