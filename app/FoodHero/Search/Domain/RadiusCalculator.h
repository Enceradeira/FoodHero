//
// Created by Jorg on 15/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RadiusCalculator : NSObject
+ (NSArray *)doUntilRightNrOfElementsReturned:(NSArray *(^)(double))elementFactory;
@end