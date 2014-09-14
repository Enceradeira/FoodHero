//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper.h"
#import "TextRepository.h"
#import "ConversationToken+Protected.h"


@implementation FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper {

}
+ (ConversationToken *)create:(Restaurant *)restaurant {
    return [[FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper alloc] initWithRestaurant:restaurant];
}

- (NSString *)getTokenName {
    return @"FH:SuggestionWithConfirmationIfInNewPreferredRangeCheaper";
}

- (NSString *)getText {
    return [self.textRepository getSuggestionWithConfirmationIfInNewPreferredRangeCheaper];
}
@end