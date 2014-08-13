//
// Created by Jorg on 10/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "WhatToDoNextTableViewController.h"
#import "ConversationViewStateListOnlyInput.h"
#import "DesignByContractException.h"
#import "UGoodBye.h"
#import "UWantsToSearchForAnotherRestaurant.h"
#import "WhatToDoNextTabelViewCell.h"


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
    [self.parentController setViewState:[ConversationViewStateListOnlyInput create:self.parentController animationDuration:animationDuration animationCurve:animationCurve]];
}

- (void)notifyUserWantsTextInput:(CGFloat)height animationCurve:(UIViewAnimationCurve)curve animationDuration:(double)duration {
    [self.parentController setViewState:[ConversationViewStateListOnlyInput create:self.parentController animationDuration:duration animationCurve:curve]];
}

- (void)sendUserInput {
    if (self.selectedCell == nil) {
        @throw [DesignByContractException createWithReason:@"method should not be called without a cell beeing selected first"];
    }
    [self.appService addUserInput:((WhatToDoNextTabelViewCell *) self.selectedCell).answer];
}

@end