//
// Created by Jorg on 24/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper.h"
#import "Restaurant.h"
#import "TyphoonComponents.h"
#import "TextRepository.h"


@implementation FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper {

}
+ (ConversationToken *)create:(Restaurant *)restaurant {
    return [[FHSuggestionWithConfirmationIfInNewPreferredRangeCheaper alloc] initWithRestaurant:restaurant];
}

- (NSString *)getTokenName {
    return @"FH:SuggestionWithConfirmationIfInNewPreferredRangeCheaper";
}

- (NSString *)getText {
    TextRepository * textRepository = [(id <ApplicationAssembly>) [TyphoonComponents factory] textRepository];
    return [textRepository getSuggestionWithConfirmationIfInNewPreferredRangeCheaper];
}
@end