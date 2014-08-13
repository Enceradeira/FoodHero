//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FeedbackTableViewController.h"
#import "FeedbackTableViewCell.h"
#import "ConversationViewStateListOrTextInput.h"
#import "ConversationViewStateListOnlyInput.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "DesignByContractException.h"


@implementation FeedbackTableViewController {
    ConversationAppService *_appService;
    ConversationViewController *_parentController;
    FeedbackTableViewCell *_selectedCell;
}
- (void)setConversationAppService:(ConversationAppService *)service {
    _appService = service;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRows];
}

- (NSInteger)numberOfRows {
    return [_appService getFeedbackCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCuisineTableViewCell:tableView indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self rowHeight];
}

- (CGFloat)rowHeight {
    return 44;
}

- (UITableViewCell *)getCuisineTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    FeedbackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feedback" forIndexPath:indexPath];
    cell.feedback = [_appService getFeedback:(NSUInteger) indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _selectedCell = (FeedbackTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    _parentController.userTextField.text =  @"";
    [_parentController animateViewThatMovesToTextInput:_selectedCell.textLabel completion:^(BOOL completed) {
        _parentController.userTextField.text = _selectedCell.textLabel.text;
        [_parentController userTextFieldChanged:self];
        [_parentController setDefaultViewState:UIViewAnimationCurveEaseOut animationDuration:0.25];
    }];
}

- (void)setParentController:(ConversationViewController *)controller {
    _parentController = controller;
}

- (void)notifyUserWantsListInput:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    [_parentController setViewState:[ConversationViewStateListOnlyInput create:_parentController animationDuration:animationDuration animationCurve:animationCurve]];
}

- (void)notifyUserWantsTextInput:(CGFloat)height animationCurve:(UIViewAnimationCurve)curve animationDuration:(double)duration {
    [_parentController setViewState:[ConversationViewStateListOnlyInput create:_parentController animationDuration:duration animationCurve:curve]];
}

- (void)sendUserInput {
    if(_selectedCell == nil){
        @throw [DesignByContractException createWithReason:@"method should not be called without a cell beeing selected first"];
    }

    [_appService addUserFeedbackForLastSuggestedRestaurant:_selectedCell.feedback];
}

- (int)optimalViewHeight {
    return (int) (self.numberOfRows * self.rowHeight);
}

@end