//
// Created by Jorg on 10/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "WhatToDoNextTableViewController.h"
#import "ConversationViewStateTextInput.h"
#import "ConversationViewStateListOnlyInput.h"
#import "DesignByContractException.h"
#import "UGoodBye.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "WhatToDoNextTabelViewCell.h"


@implementation WhatToDoNextTableViewController {

    ConversationViewController *_parentController;
    WhatToDoNextTabelViewCell *_selectedCell;
    ConversationAppService *_appService;
    UGoodBye *_goodByAnswer;
    UWantsToSearchForAnotherRestaurant *_searchAgainAnswer;
}

- (void)setConversationAppService:(ConversationAppService *)service {
    _appService = service;
}

- (void)setParentController:(ConversationViewController *)controller {
    _parentController = controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _goodByAnswer = [UGoodBye new];
    _searchAgainAnswer = [UWantsToSearchForAnotherRestaurant new];
}

- (CGFloat)rowHeight {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _selectedCell = (WhatToDoNextTabelViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    _parentController.userTextField.text = @"";
    [_parentController animateViewThatMovesToTextInput:_selectedCell.textLabel completion:^(BOOL completed) {
        _parentController.userTextField.text = _selectedCell.textLabel.text;
        [_parentController userTextFieldChanged:self];
        [_parentController setDefaultViewState:UIViewAnimationCurveEaseOut animationDuration:0.25];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WhatToDoNextTabelViewCell *cell = (WhatToDoNextTabelViewCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.answer = _goodByAnswer;
    }
    else {
        cell.answer = _searchAgainAnswer;
    }
    return cell;
}

- (void)notifyUserWantsListInput:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    [_parentController setViewState:[ConversationViewStateListOnlyInput create:_parentController animationDuration:animationDuration animationCurve:animationCurve]];
}

- (void)notifyUserWantsTextInput:(CGFloat)height animationCurve:(UIViewAnimationCurve)curve animationDuration:(double)duration {
    [_parentController setViewState:[ConversationViewStateListOnlyInput create:_parentController animationDuration:duration animationCurve:curve]];
}

- (void)sendUserInput {
    if (_selectedCell == nil) {
        @throw [DesignByContractException createWithReason:@"method should not be called without a cell beeing selected first"];
    }
    [_appService addUserInput:_selectedCell.answer];
}

- (int)optimalViewHeight {
    return (int) (2 * [self rowHeight]);
}

@end