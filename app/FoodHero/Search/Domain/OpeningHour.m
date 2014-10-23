//
// Created by Jorg on 20/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "OpeningHour.h"


@implementation OpeningHour {

}
+ (instancetype)create:(NSString *)day hours:(NSString *)hours isToday:(BOOL)isToday; {
    return [[OpeningHour alloc] init:day hours:hours isToday:isToday];
}

- (id)init:(NSString *)day hours:(NSString *)hours isToday:(BOOL)isToday; {
    self = [super init];
    if (self) {
        _day = day;
        _hours =  hours;
        _isToday = isToday;
    }
    return self;
}

@end