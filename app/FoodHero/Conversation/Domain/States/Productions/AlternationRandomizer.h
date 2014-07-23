//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"

@protocol AlternationRandomizer <NSObject>
- (ConversationToken *)chooseOneToken:(NSArray *)tagAndTokens;
@end