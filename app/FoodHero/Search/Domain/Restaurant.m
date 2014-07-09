//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Restaurant.h"


@implementation Restaurant
- (id)initWithName:(NSString *)name withVicinity:(NSString *)vicinity withTypes:(NSArray *)types {
    self = [super init];
    if (self != nil) {
        _name = name;
        _vicinity = vicinity;
        _types = types;
    }
    return self;
}

+ (Restaurant *)createWithName:(NSString *)name withVicinity:(NSString *)vicinity withTypes:(NSArray *)types {
    return [[Restaurant alloc] initWithName:name withVicinity:vicinity withTypes:types];
}
@end