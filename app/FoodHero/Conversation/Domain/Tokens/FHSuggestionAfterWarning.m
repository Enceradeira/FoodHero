//
// Created by Jorg on 29/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionAfterWarning.h"

@implementation FHSuggestionAfterWarning {

}

- (NSString *)getTokenName {
    return @"FH:SuggestionAfterWarning";
}

- (NSString *)getText {
    return @"But '%@' would be another option";
}

+ (instancetype)create:(Restaurant *)restaurant {
    return [[FHSuggestionAfterWarning alloc] initWithRestaurant:restaurant];
}

@end