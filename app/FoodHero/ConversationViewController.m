//
//  ConversationViewController.m
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationBubbleFoodHero.h"
#import "ConversationBubbleTableViewCell.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController
{
    ConversationBubbleFoodHero *_foodHeroBubble;
}

- (UIImageView *)createBackgroundImage
{
    UIImage *backgroundImage = [UIImage imageNamed:@"Cuttlery-Background.png"];
    backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0) resizingMode:UIImageResizingModeTile]; // otherwise picture is displayed compressed if to big
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    return backgroundView;
}

- (ConversationBubbleFoodHero*)createFoodHeroBubble
{
   return [[ConversationBubbleFoodHero alloc] initWithText:@"Hi there. What kind of food would you like to eat?" semanticId:@"Greeting&OpeningQuestion" viewWitdh:_conversationBubbleView.frame.size.width];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _conversationBubbleView = (UITableView*)[self.view viewWithTag:100];
    _userInputView = [self.view viewWithTag:101];
    
    _conversationBubbleView.delegate = self;
    _conversationBubbleView.dataSource = self;
    
    _conversationBubbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *backgroundView = [self createBackgroundImage];
    
    [backgroundView setFrame:_conversationBubbleView.frame];
    _conversationBubbleView.backgroundView = backgroundView;
    
    _foodHeroBubble = [self createFoodHeroBubble];
}

- (void)viewWillLayoutSubviews
{
    [_conversationBubbleView reloadData];
    
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _foodHeroBubble.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationBubbleTableViewCell *cell = (ConversationBubbleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:_foodHeroBubble.cellId forIndexPath:indexPath];
    
    _foodHeroBubble = [self createFoodHeroBubble]; // update bubble in case width has changed
    cell.bubble = _foodHeroBubble;
    return cell;
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
