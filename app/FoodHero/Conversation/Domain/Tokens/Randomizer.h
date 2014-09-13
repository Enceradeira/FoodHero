//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"

@protocol Randomizer <NSObject>
- (ConversationToken *)chooseOneToken:(NSArray *)tagAndTokens;

- (void)doOptionally:(NSString *)string byCalling:(void (^)())with;

- (NSString *)chooseOneTextFor:(NSString *)context texts:(NSArray *)texts;

@end