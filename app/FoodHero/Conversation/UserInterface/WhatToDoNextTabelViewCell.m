//
// Created by Jorg on 10/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "WhatToDoNextTabelViewCell.h"
#import "AccessibilityHelper.h"
#import "ConversationAppService.h"


@implementation WhatToDoNextTabelViewCell {

}
- (void)awakeFromNib {
    [super awakeFromNib];

    [self setIsAccessibilityElement:YES];
}


- (void)setAnswer:(ConversationToken *)answer {
    _answer = answer;
    [self UpdateView];
}

- (void)UpdateView {

    self.accessibilityLabel = self.textLabel.text;
    self.accessibilityIdentifier = [NSString stringWithFormat:@"WhatToDoNextEntry=%@", [AccessibilityHelper sanitizeForIdentifier:_answer.text]];
}
@end