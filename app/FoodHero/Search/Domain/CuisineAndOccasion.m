//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import "CuisineAndOccasion.h"


@implementation CuisineAndOccasion {

}
- (instancetype)initWithOccasion:(NSString *)occasion cuisine:(NSString *)cuisine {
    self = [super init];
    if (self != nil) {
        _occasion = occasion;
        _cuisine = cuisine;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object class] == self.class) {
        CuisineAndOccasion *cusineAndOccasion = (CuisineAndOccasion *) object;
        return ([cusineAndOccasion.occasion isEqualToString:_occasion] || (cusineAndOccasion.occasion == nil && _occasion == nil))
                && ([cusineAndOccasion.cuisine isEqualToString:_cuisine] || (cusineAndOccasion.cuisine == nil && _cuisine == nil));
    }
    return false;
}

@end