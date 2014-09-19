//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Randomizer.h"


@interface RandomizerStub : NSObject <Randomizer>
- (void)injectChoice:(NSString *)tag;

- (void)injectDontDo:(NSString *)tag;

- (void)injectChoiceForOneText:(NSString *)text;
@end