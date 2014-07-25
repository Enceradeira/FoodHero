//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "HandlePositiveSuggestionFeedbackTask.h"
#import "FHWhatToDoNext.h"


@implementation HandlePositiveSuggestionFeedbackTask {
}

+ (instancetype)create {
    return [[HandlePositiveSuggestionFeedbackTask alloc] init];
}

- (void)execute:(id <ConversationSource>)conversationSource {
    [conversationSource addToken:[FHWhatToDoNext new]];
}


@end