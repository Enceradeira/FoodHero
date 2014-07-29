//
//  ConversationViewController.m
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "ConversationViewController.h"
#import "ConversationBubbleTableViewCell.h"
#import "UCuisinePreference.h"
#import "USuggestionNegativeFeedback.h"
#import "AskUserCuisinePreferenceAction.h"
#import "AskUserSuggestionFeedbackAction.h"
#import "ConversationBubbleFoodHero.h"
#import "DesignByContractException.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"

@interface ConversationViewController ()

@end

const int InputViewHeight = 100;

@implementation ConversationViewController {
    ConversationAppService *_appService;
    Restaurant *_lastSuggestedRestaurant;
}

- (void)setConversationAppService:(ConversationAppService *)service {
    _appService = service;
}

- (UIImageView *)createBackgroundImage {
    UIImage *backgroundImage = [UIImage imageNamed:@"Cuttlery-Background.png"];
    backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile]; // otherwise picture is displayed compressed if to big

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    return backgroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Bubble View
    _bubbleView.delegate = self;
    _bubbleView.dataSource = self;
    _bubbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *backgroundView = [self createBackgroundImage];
    [backgroundView setFrame:_bubbleView.frame];
    _bubbleView.backgroundView = backgroundView;

    [[_appService statementIndexes] subscribeNext:^(id next){
        NSUInteger index;
        NSNumber *wrappedIndex = next;
        [wrappedIndex getValue:&index];

        NSMutableArray *newIndexes = [NSMutableArray new];
        NSIndexPath *newIndex = [NSIndexPath indexPathForItem:index inSection:0];
        [newIndexes addObject:newIndex];

        [_bubbleView insertRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationFade];
    }];

    // Input View
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [_bubbleView reloadData];

    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ConversationBubble *)getStatement:(NSIndexPath *)indexPath {
    ConversationBubble *bubble = [_appService getStatement:(NSUInteger) indexPath.row bubbleWidth:_bubbleView.frame.size.width];
    return bubble;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getStatement:indexPath].height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_appService getStatementCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationBubble *bubble = [self getStatement:indexPath];

    BOOL isLastRow = indexPath.row == [_appService getStatementCount] - 1;
    if (isLastRow) {
        [self configureUserInputFor:bubble];
    }

    ConversationBubbleTableViewCell *cell = (ConversationBubbleTableViewCell *) [tableView dequeueReusableCellWithIdentifier:bubble.cellId forIndexPath:indexPath];
    cell.bubble = bubble;
    return cell;
}

- (void)disableUserInput {
    [self setEnabledForCuisinePreferenceSend];
    [self.userPrefereseBritishFood setHidden:YES];
    [self.userDoesntLikeThatRestaurant setHidden:YES];
}

- (void)configureUserInputFor:(ConversationBubble *)bubble {
    [self disableUserInput];

    Restaurant *restaurant = [bubble suggestedRestaurant];
    if (restaurant != nil) {
        _lastSuggestedRestaurant = restaurant;
    }

    if ([bubble isKindOfClass:[ConversationBubbleFoodHero class]]) {
        ConversationBubbleFoodHero *foodHeroBubble = (ConversationBubbleFoodHero *) bubble;
        if (foodHeroBubble.inputAction.class == AskUserCuisinePreferenceAction.class) {
            [self.userPrefereseBritishFood setHidden:NO];
        }
        else if (foodHeroBubble.inputAction.class == AskUserSuggestionFeedbackAction.class) {
            [_userDoesntLikeThatRestaurant setHidden:NO];
        }
    }
}

- (IBAction)userCuisinePreferenceTextChanged:(id)sender {
    [self setEnabledForCuisinePreferenceSend];
}

- (void)setEnabledForCuisinePreferenceSend {
    NSString *text = self.userCuisinePreferenceText.text;
    self.userCuisinePreferenceSend.enabled = text.length > 0;
}

- (IBAction)userCuisinePreferenceSendTouchUp:(id)sender {
    NSString *text = self.userCuisinePreferenceText.text;
    
    UCuisinePreference *userInput = [UCuisinePreference create:text];
    [_appService addUserInput:userInput];    
}

- (IBAction)userChoosesIndianOrBritishFood:(id)sender {
    [self disableUserInput];
    UCuisinePreference *userInput = [UCuisinePreference create:@"British food"];
    [_appService addUserInput:userInput];
}

- (IBAction)userDoesntLikeThatRestaurant:(id)sender {
    [self disableUserInput];

    if (_lastSuggestedRestaurant == nil) {
        @throw [DesignByContractException createWithReason:@"no last suggested Restaurant found"];
    }


    USuggestionNegativeFeedback *userInput = [USuggestionFeedbackForNotLikingAtAll create:_lastSuggestedRestaurant];
    [_appService addUserInput:userInput];
}

- (void)keyboardWillShow:(id)notification {
    
    
    NSDictionary *userInfo = ((NSNotification *) notification).userInfo;
    CGRect keyboardFrameEnd = [[userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect keyboardFrameEndWithRotation = [self.view convertRect:keyboardFrameEnd fromView:nil];
    
    double keyboardAnimationDuration = ((NSNumber*)[userInfo valueForKey:@"UIKeyboardAnimationDurationUserInfoKey"]).doubleValue;
    UIViewAnimationCurve keyboardAnimationCurve = (UIViewAnimationCurve)((NSNumber*)[userInfo valueForKey:@"UIKeyboardAnimationCurveUserInfoKey"]).integerValue;
    CGFloat keyboardHeight = keyboardFrameEndWithRotation.size.height;

    CGRect viewFrame = self.view.frame;
    CGFloat viewHeight = viewFrame.size.height; // current height of the top most container view

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:keyboardAnimationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)keyboardAnimationCurve];
    _bubbleView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, viewHeight - InputViewHeight - keyboardHeight);
    _userInputView.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + _bubbleView.frame.size.height, viewFrame.size.width, InputViewHeight);
    [UIView commitAnimations];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
