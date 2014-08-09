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
    return [_appService getCuisineCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCuisineTableViewCell:tableView indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

    [_parentController userInputViewChanged:[_appService getSelectedCuisineText]];
}

- (void)setParentController:(ConversationViewController *)controller {
    _parentController = controller;
}

- (ConversationViewState *)getViewStateForListAnimationCurve:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    return [ConversationViewStateListOrTextInput create:_parentController animationDuration:animationDuration animationCurve:animationCurve];
}

- (ConversationViewState *)getViewStateForTextInputHeight:(CGFloat)height animationCurve:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    return [ConversationViewStateTextInput create:_parentController heigth:height animationCurve:animationCurve animationDuration:animationDuration];
}

- (ConversationToken *)createUserInput {
    NSString *text = _parentController.userCuisinePreferenceText.text;
    return [UCuisinePreference create:text];
}


@end
