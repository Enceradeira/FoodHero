//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AlternationBase.h"
#import "RandomAlternation.h"
#import "NSArray+LinqExtensions.h"
#import "TyphoonComponents.h"
#import "AlternationRandomizer.h"
#import "TagAndSymbol.h"
#import "DesignByContractException.h"

@implementation RandomAlternation {
    NSArray *_tagAndSymbols;
    id <AlternationRandomizer> _randomizer;
    NSMutableArray *_chosenSymbols;
}
+ (instancetype)create:(NSString *)tag1, ... {
    NSMutableArray *symbols = [NSMutableArray new];

    va_list args;
    va_start(args, tag1);
    for (id tag = tag1; tag != nil; tag = va_arg(args, id)) {
        id <RepeatSymbol> symbol = va_arg(args, id < RepeatSymbol >);
        [symbols addObject:[[TagAndSymbol alloc] initWithTag:tag symbol:symbol]];
    }

    va_end(args);

    return [[RandomAlternation alloc] initWithTags:symbols];
}

- (id)initWithTags:(NSArray *)tagAndSymbols {
    self = [super initWithSymbols:[tagAndSymbols linq_select:^(TagAndSymbol *t){
        return t.symbol;
    }]];
    if (self != nil) {
        _randomizer = [(id <ApplicationAssembly>) [TyphoonComponents factory] alternationRandomizer];
        _chosenSymbols = [NSMutableArray new];
        _tagAndSymbols = tagAndSymbols;
    }
    return self;
}

- (id <Symbol>)getNextSymbol:(NSUInteger)index {
    NSArray *candidates = [_tagAndSymbols
            linq_where:^(TagAndSymbol *t){
                return [_chosenSymbols linq_all:^(id<Symbol> s){
                    return (BOOL) (s != t.symbol);
                }];
            }];
    id <Symbol> chosenSymbol = [_randomizer chooseOneSymbol:candidates];
    if (chosenSymbol == nil) {
        @throw [DesignByContractException createWithReason:@"there should always a symbol been found"];
    }
    [_chosenSymbols addObject:chosenSymbol];
    return chosenSymbol;
}
@end