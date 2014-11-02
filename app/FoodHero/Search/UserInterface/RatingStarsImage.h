//
// Created by Jorg on 02/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RatingStarsImage : NSObject
@property(readonly, nonatomic) UIImage *image;
@property(readonly, nonatomic) NSString *name;

+ (instancetype)create:(NSString *)name;

- (id)initWithName:(NSString *)name;
@end