//
// Created by Jorg on 13/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "NoRepetionForContextRandomizer.h"
#import "DesignByContractException.h"
#import "DefaultRandomizer.h"


@implementation NoRepetionForContextRandomizer {
    NSMutableArray *_textAndBools;
    NSString *_context;
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

- (NSString *)chooseOneTextFor:(NSString *)context texts:(NSArray *)texts {
    if (![_context isEqualToString:context]) {
        return texts[0];
    }

    NSArray *newTexts = [texts linq_where:^(NSString *newText) {
        return (BOOL) ![_textAndBools linq_any:^(NSArray *textAndBool) {
            NSString *text = (NSString *) textAndBool[0];
            return (BOOL) [text isEqualToString:newText];
        }];
    }];
    [_textAndBools addObjectsFromArray:[newTexts linq_select:^(NSString *newText) {
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

- (void)configureContext:(NSString *)context {
    _context = context;
}
@end