//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestionBase.h"
#import "FHSuggestion.h"
#import "TyphoonComponents.h"
#import "Randomizer.h"
#import "TextRepository.h"


@implementation FHSuggestion {
}
+ (instancetype)create:(Restaurant *)restaurant {
    return [[FHSuggestion alloc] initWithRestaurant:restaurant];
}

- (NSString *)getTokenName {
    return @"FH:Suggestion";
}

- (NSString *)getText {
    TextRepository * textRepository = [(id <ApplicationAssembly>) [TyphoonComponents factory] textRepository];
    return [textRepository getSuggestion];
}
@end