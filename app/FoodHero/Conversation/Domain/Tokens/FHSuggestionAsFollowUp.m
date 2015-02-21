//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionAsFollowUp.h"

@implementation FHSuggestionAsFollowUp {

}
+ (instancetype)create:(Restaurant *)restaurant {
    return [[FHSuggestionAsFollowUp alloc] initWithRestaurant:restaurant];
}

- (NSString *)getTokenName {
    return @"FH:SuggestionAsFollowUp";
}

- (NSString *)getText {
    return @"What about '%@' then?";
}

@end