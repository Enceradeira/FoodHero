//
//  CuisineTableViewController.m
//  FoodHero
//
//  Created by Jorg on 08/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CuisineTableViewController.h"
#import "CuisineTableViewCell.h"
#import "ConversationViewStateListOrTextInput.h"
#import "ConversationViewStateTextInput.h"
#import "UCuisinePreference.h"

@implementation CuisineTableViewController {
    ConversationAppService *_appService;
    ConversationViewController *_parentController;
}

- (void)setConversationAppService:(ConversationAppService *)service {
    _appService = service;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRows];
}

- (NSInteger)numberOfRows {
    return [_appService getCuisineCount];
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
    CuisineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cuisine" forIndexPath:indexPath];
    cell.cuisine = [_appService getCuisine:(NSUInteger) indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CuisineTableViewCell *cell = (CuisineTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = !cell.isSelected;

    _parentController.userTextField.text = [_appService getSelectedCuisineText];
    [_parentController userTextFieldChanged:self];
}

- (void)setParentController:(ConversationViewController *)controller {
    _parentController = controller;
}

- (void)notifyUserWantsListInput:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    [_parentController setViewState:[ConversationViewStateListOrTextInput create:_parentController animationDuration:animationDuration animationCurve:animationCurve]];
}

- (void)notifyUserWantsTextInput:(CGFloat)height animationCurve:(UIViewAnimationCurve)curve animationDuration:(double)duration {
    [_parentController setViewState:[ConversationViewStateTextInput create:_parentController heigth:height animationCurve:curve animationDuration:duration]];
}

- (void)sendUserInput {
    NSString *text = _parentController.userTextField.text;
    [_appService addUserInput:[UCuisinePreference create:text]];
}

- (NSInteger)optimalViewHeight {
    return (NSInteger) (self.numberOfRows * self.rowHeight);
}


@end
