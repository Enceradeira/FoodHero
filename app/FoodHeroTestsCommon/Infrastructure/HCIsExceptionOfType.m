//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "HCIsExceptionOfType.h"


@implementation HCIsExceptionOfType {
    Class _expectedExceptionClass;
    NSException *_thrownException;
}
- (instancetype)initWithExceptionClass:(Class)exceptionClass {
    self = [super init];
    if (self)
        _expectedExceptionClass = exceptionClass;
        _thrownException = nil;
    return self;
}

- (BOOL)matches:(id)item {
    void (^block)(void) = item;
    @try{
        block();
        return NO;
    }
    @catch (NSException * exception){
        _thrownException = exception;
        return [exception isKindOfClass:_expectedExceptionClass];
    }
}

+ (id)HC_throwsExceptionOfType:(Class)exceptionClass {
    return [[HCIsExceptionOfType alloc] initWithExceptionClass:exceptionClass];
}

- (void)describeTo:(id <HCDescription>)description {
    [description appendText:[NSString stringWithFormat:@"exception of type %@ being thrown", _expectedExceptionClass]];
}

@end

id HC_throwsExceptionOfType(Class exceptionClass)
{
    return [HCIsExceptionOfType throwsExceptionOfType:exceptionClass];
}