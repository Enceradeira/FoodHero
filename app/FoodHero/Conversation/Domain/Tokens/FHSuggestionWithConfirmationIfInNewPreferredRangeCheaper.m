//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper.h"
#import "Restaurant.h"


@implementation FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper {

}
+ (ConversationToken *)create:(Restaurant *)restaurant {
    return [[FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper alloc] initWithRestaurant:restaurant];
}

- (NSString *)getTokenName {
    return @"FH:SuggestionWithConfirmationIfInNewPreferredRangeCheaper";
}

- (NSString *)getText {
    return @"If you like it cheaper, the '%@' could be your choice";
}
@end