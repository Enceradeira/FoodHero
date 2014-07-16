//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "USuggestionFeedback.h"


@implementation USuggestionFeedback {

}
+ (USuggestionFeedback *)create:(NSString *)parameter {
    return [[USuggestionFeedback alloc] initWithParameter:@"U:SuggestionFeedback" parameter:parameter];
}
@end