//
// Created by Jorg on 22/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEnvironment.h"


@interface EnvironmentStub : NSObject <IEnvironment>
- (void)injectNow:(NSDate *)date;
@end