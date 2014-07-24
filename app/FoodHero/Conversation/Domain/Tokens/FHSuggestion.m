//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionBase.h"
#import "FHSuggestion.h"


@implementation FHSuggestion {
}
+ (instancetype)create:(Restaurant *)restaurant {
    return [[FHSuggestion alloc] initWithRestaurant:restaurant];
}

- (NSString *)getTokenName {
    return @"FH:Suggestion";
}

- (NSString *)getText {
    return @"Maybe you like the '%@'?";
}
@end