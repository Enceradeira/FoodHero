//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGoodByeAfterSuccess.h"
#import "TextRepository.h"
#import "ConversationToken+Protected.h"

@implementation FHGoodByeAfterSuccess {

}
- (instancetype)init {
    NSString *text = [[self textRepository] getGoodByeAfterSuccess];
    self = [super initWithSemanticId:@"FH:GoodByeAfterSuccess" text:text];
    return self;
}

@end