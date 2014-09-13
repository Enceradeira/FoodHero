//
// Created by Jorg on 13/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Randomizer.h"


@interface TextRepository : NSObject

- (instancetype)initWithRandomizer:(id <Randomizer>)randomizer;

- (NSString *)getFemaleCelebrity;

- (NSString *)getMaleCelebrity;

- (NSString *)getGreeting;

- (NSString *)getPlace;

- (NSString *)getSuggestion;

- (NSString *)getCelebrity;
@end