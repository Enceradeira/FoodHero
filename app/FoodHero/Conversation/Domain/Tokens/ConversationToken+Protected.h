//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationToken.h"
#import "ITextRepository.h"
#import "ISoundRepository.h"

@interface ConversationToken (Protected)
+ (id <ITextRepository>)textRepository;

- (id <ITextRepository>)textRepository;
@end