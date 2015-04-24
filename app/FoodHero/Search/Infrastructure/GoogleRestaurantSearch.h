//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantSearchService.h"
#import "IEnvironment.h"

@interface GoogleRestaurantSearch : NSObject <RestaurantSearchService>

@property(nonatomic) NSString *baseAddress;
@property(nonatomic) NSTimeInterval timeout;

- (id)initWithEnvironment:(id <IEnvironment>)environment onlyOpenNow:(BOOL)onlyOpenNow;
@end