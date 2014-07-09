//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Restaurant.h"


@implementation Restaurant
- (id)initWithName:(NSString *)name withVicinity:(NSString *)vicinity {
    self = [super init];
    if (self != nil) {
        self.name = name;
        self.vicinity = vicinity;
    }
    return self;
}

+ (Restaurant *)createWithName:(NSString *)name withVicinity:(NSString *)vicinity {
    return [[Restaurant alloc] initWithName:name withVicinity:vicinity];
}
@end