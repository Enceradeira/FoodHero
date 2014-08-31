//
// Created by Jorg on 13/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UserInputViewTableViewController.h"
#import "FeedbackTableViewCell.h"
#import "DesignByContractException.h"
#import "ConversationTokenTableViewCell.h"
#import "ConversationViewStateListOnlyInput.h"


@implementation UserInputViewTableViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self rowHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _selectedCell = (FeedbackTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    self.parentController.userTextField.text = @"";
    [self.parentController animateViewThatMovesToTextInput:self.selectedCell.textLabel completion:^(BOOL completed) {
        self.parentController.userTextField.text = self.selectedCell.textLabel.text;
        [self.parentController userTextFieldChanged:self];
        [self.parentController setDefaultViewState:UIViewAnimationCurveEaseOut animationDuration:0.25];
    }];
}

- (CGFloat)rowHeight {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRows];
}

- (NSInteger)numberOfRows {
    @throw [DesignByContractException createWithReason:@"method must be overridden by subclass"];
}

- (NSInteger)optimalViewHeight {
    return (NSInteger) (self.numberOfRows * self.rowHeight);
}

- (void)notifyUserWantsListInput:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    [self.parentController setViewState:[ConversationViewStateListOnlyInput create:self.parentController animationDuration:animationDuration animationCurve:animationCurve]];
}

- (void)notifyUserWantsTextInput:(CGFloat)height animationCurve:(UIViewAnimationCurve)curve animationDuration:(double)duration {
    [self.parentController setViewState:[ConversationViewStateListOnlyInput create:self.parentController animationDuration:duration animationCurve:curve]];
}

- (void)sendUserInput {
    if (self.selectedCell == nil) {
        @throw [DesignByContractException createWithReason:@"method should not be called without a cell beeing selected first"];
    }
    [self.appService addUserInput:((ConversationTokenTableViewCell *) self.selectedCell).token];
}


@end