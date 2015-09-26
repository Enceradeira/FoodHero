//
// Created by Jorg on 26/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IConversationAppService <NSObject>
- (void)startWithFeedbackRequest:(BOOL)isWithFeedbackRequest;
@end