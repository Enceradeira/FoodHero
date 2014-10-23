//
// Created by Jorg on 13/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "NoRepetionForContextRandomizer.h"
#import "DesignByContractException.h"


@implementation NoRepetionForContextRandomizer {
    NSMutableArray *_textAndBools;
    NSString const *_context;
}
- (id)init {
    self = [super init];
    if (self) {
        _textAndBools = [NSMutableArray new];
    }

    return self;
}

- (ConversationToken *)chooseOneToken:(NSArray *)tagAndTokens {
    @throw [DesignByContractException createWithReason:@"Not implemented"];
}

- (void)doOptionally:(NSString *)string byCalling:(void (^)())with {
    @throw [DesignByContractException createWithReason:@"Not implemented"];
}

- (TextAndSound *)chooseOneTextFor:(NSString const *)context texts:(NSArray *)texts {
    if (![_context isEqualToString:(NSString *) context]) {
        return texts[0];
    }

    NSArray *newTexts = [texts linq_where:^(TextAndSound *newText) {
        return (BOOL) ![_textAndBools linq_any:^(NSArray *textAndBool) {
            TextAndSound *text = (TextAndSound *) textAndBool[0];
            return (BOOL) [text isEqual:newText];
        }];
    }];
    [_textAndBools addObjectsFromArray:[newTexts linq_select:^(TextAndSound *newText) {
        return [@[newText, @(NO)] mutableCopy];
    }]];

    NSArray *chosenTextAndBools = [_textAndBools linq_where:^(NSArray *textAndBool) {
        return (BOOL) ([texts containsObject:textAndBool[0]] && ![((NSNumber *) textAndBool[1]) boolValue]);
    }];

    if (chosenTextAndBools.count > 0) {
        NSMutableArray *chosenTextAndBool = [chosenTextAndBools linq_firstOrNil];
        chosenTextAndBool[1] = @(YES);
        return chosenTextAndBool[0];
    }
    else {
        return texts[0];
    }
}

- (BOOL)hasMoreForContext {
    return [_textAndBools linq_any:^(NSArray *textAndBool) {
        return (BOOL) ![((NSNumber *) textAndBool[1]) boolValue];
    }];
}

- (void)configureContext:(NSString const *)context {
    _context = context;
}
@end