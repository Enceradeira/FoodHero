//
// Created by Jorg on 29/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHWarningIfNotInPreferredRangeTooExpensiveState.h"
#import "FHWarningIfNotInPreferredRangeTooCheap.h"
#import "FHWarningIfNotInPreferredRangeTooExpensive.h"


@implementation FHWarningIfNotInPreferredRangeTooExpensiveState {

}
- (instancetype)init {
    self = [super initWithToken:[FHWarningIfNotInPreferredRangeTooExpensive class]];
    return self;
}
@end