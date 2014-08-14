//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Restaurant.h"


@implementation Restaurant
- (id)initWithName:(NSString *)name vicinity:(NSString *)vicinity types:(NSArray *)types placeId:(NSString *)placeId {
    self = [super initWithPlaceId:placeId];
    if (self != nil) {
        _name = name;
        _vicinity = vicinity;
        _types = types;
    }
    return self;
}

+ (Restaurant *)createWithName:(NSString *)name vicinity:(NSString *)vicinity types:(NSArray *)types placeId:(NSString *)placeId {
    return [[Restaurant alloc] initWithName:name vicinity:vicinity types:types placeId:placeId];
}
@end