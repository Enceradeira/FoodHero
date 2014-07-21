//
// Created by Jorg on 21/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "DefaultAlternationRandomizer.h"
#import "DesignByContractException.h"
#import "TagAndSymbol.h"


@implementation DefaultAlternationRandomizer {

}
- (id <Symbol>)chooseOneSymbol:(NSArray *)tagAndSymbols {
    if (tagAndSymbols.count == 0) {
        @throw [DesignByContractException createWithReason:@"there must be at least one symbol to choose from"];
    }

    int randomIndex = arc4random() % tagAndSymbols.count;
    return ((TagAndSymbol *) tagAndSymbols[(NSUInteger) randomIndex]).symbol;
}

@end