//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive.h"

@implementation FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive {

}
+ (ConversationToken *)create:(Restaurant *)restaurant {
    return [[FHSuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive alloc] initWithRestaurant:restaurant];
}

- (NSString *)getTokenName {
    return @"FH:SuggestionWithConfirmationIfInNewPreferredRangeMoreExpensive";
}

- (NSString *)getText {
    return @"The '%@' is smarter than the last one";
}

@end