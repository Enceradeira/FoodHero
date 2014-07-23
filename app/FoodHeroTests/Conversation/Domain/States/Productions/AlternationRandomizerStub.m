//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "AlternationRandomizerStub.h"
#import "TagAndToken.h"


@implementation AlternationRandomizerStub {

    NSString *_choosenTag;
}
- (void)injectChoice:(NSString *)tag {
    _choosenTag = tag;
}

- (ConversationToken *)chooseOneToken:(NSArray *)tagAndTokens {
    ConversationToken *result = [[tagAndTokens
            linq_where:^(TagAndToken *t){
                return [t.tag isEqualToString:_choosenTag];
            }]
            linq_select:^(TagAndToken *t){
                return t.token;
            }].linq_firstOrNil;
    if (result == nil) {
        return ((TagAndToken *) tagAndTokens[0]).token;
    }
    return result;
}

@end