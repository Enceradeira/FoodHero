//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USuggestionNegativeFeedback.h"


@interface USuggestionFeedbackForNotLikingAtAll : USuggestionNegativeFeedback
+ (instancetype)create:(Restaurant *)restaurant text:(NSString *)text;
@end