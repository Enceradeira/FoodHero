//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "DefaultTokenRandomizer.h"
#import "DesignByContractException.h"
#import "TagAndToken.h"


@implementation DefaultTokenRandomizer {

}
- (ConversationToken *)chooseOneToken:(NSArray *)tagAndTokens {
    if (tagAndTokens.count == 0) {
        @throw [DesignByContractException createWithReason:@"there must be at least one symbol to choose from"];
    }

    int randomIndex = arc4random() % tagAndTokens.count;
    return ((TagAndToken *) tagAndTokens[(NSUInteger) randomIndex]).token;
}

- (void)doOptionally:(NSString *)string byCalling:(void (^)())block {
    int randomIndex = arc4random() % 2;
    if (randomIndex) {
        block();
    }
}


@end