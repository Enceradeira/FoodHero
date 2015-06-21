//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon.h>
#import "ApplicationAssembly.h"


@interface TyphoonComponents : NSObject
+ (id <ApplicationAssembly>)getAssembly;

+ (void)reset;

+ (void)configure:(TyphoonAssembly *)assembly;

+ (TyphoonStoryboard *)storyboard;
@end