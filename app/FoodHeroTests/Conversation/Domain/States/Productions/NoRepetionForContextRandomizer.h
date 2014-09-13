//
// Created by Jorg on 13/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Randomizer.h"


@interface NoRepetionForContextRandomizer : NSObject <Randomizer>
- (BOOL)hasMoreForContext;

- (void)configureContext:(NSString *)context;
@end