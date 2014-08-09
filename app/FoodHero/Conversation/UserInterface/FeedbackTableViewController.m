//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FeedbackTableViewController.h"
#import "UserInputViewSubscriber.h"
#import "ConversationAppService.h"
#import "FeedbackTableViewCell.h"


@implementation FeedbackTableViewController {
    ConversationAppService *_appService;
    id <UserInputViewSubscriber> _delegate;
}
- (void)setConversationAppService:(ConversationAppService *)service {
    _appService = service;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_appService getFeedbackCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCuisineTableViewCell:tableView indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)getCuisineTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feedback" forIndexPath:indexPath];
    cell.feedback = [_appService getFeedback:(NSUInteger) indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    FeedbackTableViewCell *cell = (FeedbackTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    [_delegate userInputViewChanged:cell.feedback.text];
}


- (void)setDelegate:(id <UserInputViewSubscriber>)delegate {
    _delegate = delegate;
}
@end