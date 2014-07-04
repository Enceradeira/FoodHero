//
//  ConversationViewController.m
//  FoodHero
//
//  Created by Jorg on 30/06/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationViewController.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController
{
    UITableView *_conversationBubbleView;
    UIView *_userInputView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _conversationBubbleView = (UITableView*)[self.view viewWithTag:100];
    _userInputView = [self.view viewWithTag:101];
    
    _conversationBubbleView.delegate = self;
    _conversationBubbleView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
