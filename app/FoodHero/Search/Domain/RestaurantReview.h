//
// Created by Jorg on 31/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RestaurantReview : NSObject

@property(nonatomic, readonly) NSString *text;

+ (instancetype)create:(NSString *)review;

- (id)init:(NSString *)review;
@end