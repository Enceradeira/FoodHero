//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "DefaultAlternationRandomizer.h"
#import "DesignByContractException.h"
#import "TagAndToken.h"


@implementation DefaultAlternationRandomizer {

}
- (ConversationToken *)chooseOneToken:(NSArray *)tagAndTokens {
    if (tagAndTokens.count == 0) {
        @throw [DesignByContractException createWithReason:@"there must be at least one symbol to choose from"];
    }

    int randomIndex = arc4random() % tagAndTokens.count;
    return ((TagAndToken *) tagAndTokens[(NSUInteger) randomIndex]).token;
}

@end