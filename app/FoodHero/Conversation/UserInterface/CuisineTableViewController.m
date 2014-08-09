//
//  CuisineTableViewController.m
//  FoodHero
//
//  Created by Jorg on 08/08/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CuisineTableViewController.h"
#import "CuisineTableViewCell.h"
#import "ConversationAppService.h"
#import "ConversationViewState.h"
#import "ConversationViewStateListOrTextInput.h"
#import "ConversationViewStateTextInput.h"
#import "UCuisinePreference.h"

@implementation CuisineTableViewController {
    ConversationAppService *_appService;
    id <UserInputViewSubscriber> _delegate;
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

    [_delegate userInputViewChanged:[_appService getSelectedCuisineText]];
}


- (void)setDelegate:(id <UserInputViewSubscriber>)delegate {
    _delegate = delegate;
}

- (ConversationViewState *)getViewStateForList:(ConversationViewController *)mainController animationCurve:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    return [ConversationViewStateListOrTextInput create:mainController animationDuration:animationDuration animationCurve:animationCurve];
}

- (ConversationViewState *)getViewStateForTextInput:(ConversationViewController *)mainController height:(CGFloat)height animationCurve:(enum UIViewAnimationCurve)animationCurve animationDuration:(double)animationDuration {
    return [ConversationViewStateTextInput create:mainController heigth:height animationCurve:animationCurve animationDuration:animationDuration];
}

- (ConversationToken *)createUserInput:(ConversationViewController *)mainController {
    NSString *text = mainController.userCuisinePreferenceText.text;
    return  [UCuisinePreference create:text];
}


@end
