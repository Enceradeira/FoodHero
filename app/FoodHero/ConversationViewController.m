//
//  ConversationViewController.m
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationBubbleTableViewCell.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController {
    ConversationAppService *_appService;
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
    _userInputView = [self.view viewWithTag:101];

    _conversationBubbleView.delegate = self;
    _conversationBubbleView.dataSource = self;

    _conversationBubbleView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIImageView *backgroundView = [self createBackgroundImage];

    [backgroundView setFrame:_conversationBubbleView.frame];
    _conversationBubbleView.backgroundView = backgroundView;
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
    ConversationBubble *bubble = [_appService getStatement:indexPath.row bubbleWidth:_conversationBubbleView.frame.size.width];
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
    ConversationBubbleTableViewCell *cell = (ConversationBubbleTableViewCell *) [tableView dequeueReusableCellWithIdentifier:bubble.cellId forIndexPath:indexPath];
    cell.bubble = bubble;
    return cell;
}

- (IBAction)userChoosesIndianOrBritishFood:(id)sender {
    [_appService addStatement:@"British food"];

    NSInteger newIndex = [_appService getStatementCount] - 1;

    NSIndexPath *indexNewRow = [NSIndexPath indexPathForItem:newIndex inSection:0];
    NSArray *indexNewRows = [NSArray arrayWithObject:indexNewRow];
    [_conversationBubbleView insertRowsAtIndexPaths:indexNewRows withRowAnimation:UITableViewRowAnimationFade];
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
