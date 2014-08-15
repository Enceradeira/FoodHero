//
// Created by Jorg on 15/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RestaurantsAtRadius : NSObject
@property(nonatomic) double radius;
@property(nonatomic) NSArray *restaurants;

+ (instancetype)create:(double)radius restaurants:(NSArray *)restaurants;

- (id)initWithRadius:(double)radius restaurants:(NSArray *)restaurants;

@end