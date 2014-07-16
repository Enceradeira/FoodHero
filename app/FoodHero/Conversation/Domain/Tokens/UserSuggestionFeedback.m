//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UserSuggestionFeedback.h"


@implementation UserSuggestionFeedback {

}
+ (UserSuggestionFeedback *)create:(NSString *)parameter {
    return [[UserSuggestionFeedback alloc] init:@"U:SuggestionFeedback" parameter:parameter];
}
@end