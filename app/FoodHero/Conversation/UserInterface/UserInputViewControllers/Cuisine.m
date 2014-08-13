//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Cuisine.h"


@implementation Cuisine {

}
+ (instancetype)create:(NSString *)name {
    return [[Cuisine alloc] initWithName:name];
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self != nil) {
        _name = name;
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    _isSelectedTimeStamp = [NSDate date];
}

@end