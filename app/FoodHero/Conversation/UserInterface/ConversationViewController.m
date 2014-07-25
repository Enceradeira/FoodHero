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

@implementation ConversationViewController {
    ConversationAppService *_appService;
    __weak IBOutlet UIButton *_userPreferesBritishFood;
    __weak IBOutlet UIButton *_userDoesntLikeThatRestaurant;
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

    _conversationBubbleView = (UITableView *) [self.view viewWithTag:100];
    _conversationBubbleView.delegate = self;
    _conversationBubbleView.dataSource = self;
    _conversationBubbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView *backgroundView = [self createBackgroundImage];
    [backgroundView setFrame:_conversationBubbleView.frame];
    _conversationBubbleView.backgroundView = backgroundView;

    [[_appService statementIndexes] subscribeNext:^(id next){
        NSUInteger index;
        NSNumber *wrappedIndex = next;
        [wrappedIndex getValue:&index];

        NSMutableArray *newIndexes = [NSMutableArray new];
        NSIndexPath *newIndex = [NSIndexPath indexPathForItem:index inSection:0];
        [newIndexes addObject:newIndex];

        [_conversationBubbleView insertRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)viewWillLayoutSubviews {
    [_conversationBubbleView reloadData];

    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ConversationBubble *)getStatement:(NSIndexPath *)indexPath {
    ConversationBubble *bubble = [_appService getStatement:(NSUInteger) indexPath.row bubbleWidth:_conversationBubbleView.frame.size.width];
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
    [_userPreferesBritishFood setHidden:YES];
    [_userDoesntLikeThatRestaurant setHidden:YES];
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
            [_userPreferesBritishFood setHidden:NO];
        }
        else if (foodHeroBubble.inputAction.class == AskUserSuggestionFeedbackAction.class) {
            [_userDoesntLikeThatRestaurant setHidden:NO];
        }
    }
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
