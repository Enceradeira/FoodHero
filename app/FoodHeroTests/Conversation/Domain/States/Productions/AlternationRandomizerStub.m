//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "AlternationRandomizerStub.h"
#import "TagAndSymbol.h"


@implementation AlternationRandomizerStub {

    NSString *_choosenTag;
}
- (void)injectChoice:(NSString *)tag {
    _choosenTag = tag;
}

- (id <Symbol>)chooseOneSymbol:(NSArray *)tagAndSymbols {
    id <Symbol> result = [[tagAndSymbols
            linq_where:^(TagAndSymbol *t){
                return [t.tag isEqualToString:_choosenTag];
            }]
            linq_select:^(TagAndSymbol *t){
                return t.symbol;
            }].linq_firstOrNil;
    if( result == nil ){
        return ((TagAndSymbol *)tagAndSymbols[0]).symbol;
    }
    return result;
}

@end