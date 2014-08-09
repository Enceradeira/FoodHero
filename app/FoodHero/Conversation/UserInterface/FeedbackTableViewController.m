//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FeedbackTableViewController.h"
#import "FeedbackTableViewCell.h"
#import "ConversationViewStateListOrTextInput.h"
#import "ConversationViewStateListOnlyInput.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"


@implementation FeedbackTableViewController {
    ConversationAppService *_appService;
    ConversationViewController *_parentController;
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
    _parentController.userCuisinePreferenceText.text = cell.feedback.text;
    [_parentController userCuisinePreferenceTextChanged:self];
}

- (void)setParentController:(ConversationViewController *)controller {
    _parentController = controller;
}

- (void)notifyUserWantsListInput:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    [_parentController changeViewState:[ConversationViewStateListOnlyInput create:_parentController animationDuration:animationDuration animationCurve:animationCurve]];
}

- (void)notifyUserWantsTextInput:(CGFloat)height animationCurve:(UIViewAnimationCurve)curve animationDuration:(double)duration {
    [_parentController changeViewState:[ConversationViewStateListOnlyInput create:_parentController animationDuration:duration animationCurve:curve]];
}

- (void)sendUserInput {
    Restaurant *lastSuggestedRestaurant = [_appService getLastSuggestedRestaurant];
    [_appService addUserInput:[USuggestionFeedbackForNotLikingAtAll create:lastSuggestedRestaurant]];
}


@end