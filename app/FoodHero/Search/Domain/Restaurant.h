//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"


@interface Restaurant : Place
@property(nonatomic, readonly) NSString *vicinity;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSArray *types;

+ (Restaurant *)createWithName:(NSString *)name vicinity:(NSString *)vicinity types:(NSArray *)types placeId:(id)placeId;
@end