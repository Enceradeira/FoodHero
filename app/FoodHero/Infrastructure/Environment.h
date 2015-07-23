//
// Created by Jorg on 22/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEnvironment.h"

extern NSString * const UrlFhPlacesApiInProduction;
extern NSString * const UrlFhPlacesApiInIntegration;

@interface Environment : NSObject <IEnvironment>
@property(nonatomic) NSString *systemVersion;

+ (BOOL)isRunningInSimulator;
@end