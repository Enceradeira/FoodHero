//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "DefaultRandomizer.h"
#import "DesignByContractException.h"
#import "TagAndToken.h"


@implementation DefaultRandomizer {

}
- (ConversationToken *)chooseOneToken:(NSArray *)tagAndTokens {
    return ((TagAndToken *) [self chooseOneFrom:tagAndTokens]).token;

}

- (id)chooseOneFrom:(NSArray *)array {
    if (array.count == 0) {
        @throw [DesignByContractException createWithReason:@"there must be at least one symbol to choose from"];
    }

    NSInteger randomIndex = arc4random() % array.count;
    return (array[(NSUInteger) randomIndex]);
}

- (void)doOptionally:(NSString *)string byCalling:(void (^)())block {
    NSInteger randomIndex = arc4random() % 2;
    if (randomIndex) {
        block();
    }
}

- (NSString *)chooseOneTextFrom:(NSArray *)texts {
    return [self chooseOneFrom:texts];
}

@end