//
// Created by Jorg on 10/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationTokenTableViewCell.h"
#import "AccessibilityHelper.h"


@implementation ConversationTokenTableViewCell {

    NSString *_accessibilityId;
}
- (void)awakeFromNib {
    [super awakeFromNib];

    [self setIsAccessibilityElement:YES];
}


- (void)setToken:(ConversationToken *)token accessibilityId:(NSString *)accessibilityId {
    _token = token;
    _accessibilityId = accessibilityId;
    [self UpdateView];
}

- (void)UpdateView {

    self.accessibilityLabel = self.textLabel.text;
    self.accessibilityIdentifier = [NSString stringWithFormat:@"%@=%@", _accessibilityId, [AccessibilityHelper sanitizeForIdentifier:_token.text]];
}
@end