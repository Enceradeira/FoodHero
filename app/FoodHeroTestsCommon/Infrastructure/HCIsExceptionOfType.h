//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OCHamcrest/HCBaseMatcher.h>


@interface HCIsExceptionOfType : HCBaseMatcher
+ (id)HC_throwsExceptionOfType:(Class)exceptionClass;
@end

FOUNDATION_EXPORT id HC_throwsExceptionOfType(id object);


#ifdef HC_SHORTHAND
#define throwsExceptionOfType HC_throwsExceptionOfType
#endif
