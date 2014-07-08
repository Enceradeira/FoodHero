//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Restaurant.h"


@implementation Restaurant
- (id)initWithName:(NSString *)name place:(NSString *)place {
    self = [super init];
    if (self != nil) {
        self.name = name;
        self.place = place;
    }
    return self;
}

+ (Restaurant *)createWithName:(NSString *)string place:(NSString *)place {
    return [[Restaurant alloc] initWithName:string place:place];
}
@end