//
// Created by Jorg on 20/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "OpeningHour.h"


@implementation OpeningHour {

}
+ (instancetype)create:(NSString *)day hours:(NSString *)hours isToday:(BOOL)isToday; {
    return [[OpeningHour alloc] initWithDay:day hours:hours isToday:isToday];
}

- (id)initWithDay:(NSString *)day hours:(NSString *)hours isToday:(BOOL)isToday; {
    self = [super init];
    if (self) {
        _day = day;
        _hours =  hours;
        _isToday = isToday;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _day = [coder decodeObjectForKey:@"_day"];
        _hours = [coder decodeObjectForKey:@"_hours"];
        _isToday = [coder decodeBoolForKey:@"_isToday"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.day forKey:@"_day"];
    [coder encodeObject:self.hours forKey:@"_hours"];
    [coder encodeBool:self.isToday forKey:@"_isToday"];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToHour:other];
}

- (BOOL)isEqualToHour:(OpeningHour *)hour {
    if (self == hour)
        return YES;
    if (hour == nil)
        return NO;
    if (self.day != hour.day && ![self.day isEqualToString:hour.day])
        return NO;
    if (self.hours != hour.hours && ![self.hours isEqualToString:hour.hours])
        return NO;
    if (self.isToday != hour.isToday)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.day hash];
    hash = hash * 31u + [self.hours hash];
    hash = hash * 31u + self.isToday;
    return hash;
}


@end