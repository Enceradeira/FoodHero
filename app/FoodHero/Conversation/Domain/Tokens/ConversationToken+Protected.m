//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationToken+Protected.h"
#import "TextRepository.h"
#import "ApplicationAssembly.h"
#import "TyphoonComponents.h"


@implementation ConversationToken (Protected)

+ (TextRepository *)textRepository {
    return [(id <ApplicationAssembly>) [TyphoonComponents factory] textRepository];
}

- (TextRepository *)textRepository {
    return [ConversationToken textRepository];
}


@end