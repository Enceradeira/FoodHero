//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RandomizerStub.h"
#import "TagAndToken.h"


@implementation RandomizerStub {

    NSString *_choosenTag;
    NSString *_dontToTag;
    NSString *_choiseForOneText;
}
- (void)injectChoice:(NSString *)tag {
    _choosenTag = tag;
}

- (ConversationToken *)chooseOneToken:(NSArray *)tagAndTokens {
    ConversationToken *result = [[tagAndTokens
            linq_where:^(TagAndToken *t) {
                return [t.tag isEqualToString:_choosenTag];
            }]
            linq_select:^(TagAndToken *t) {
                return t.token;
            }].linq_firstOrNil;
    if (result == nil) {
        return ((TagAndToken *) tagAndTokens[0]).token;
    }
    return result;
}

- (void)doOptionally:(NSString *)tag byCalling:(void (^)())block {
    if (![tag isEqualToString:_dontToTag]) {
        block();
    }
}

- (TextAndSound *)chooseOneTextFor:(NSString const *)context texts:(NSArray *)texts {
    if (_choiseForOneText != nil) {
        return [[texts linq_where:^(TextAndSound *textAndSound) {
            return [textAndSound.text isEqualToString:_choiseForOneText];
        }] linq_firstOrNil];
    }
    return texts[0];
}

- (void)injectDontDo:(NSString *)tag {
    _dontToTag = tag;
}

- (void)injectChoiceForOneText:(NSString *)text {
    _choiseForOneText = text;
}
@end