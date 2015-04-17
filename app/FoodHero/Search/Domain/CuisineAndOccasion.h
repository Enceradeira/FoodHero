//
// Created by Jorg on 17/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CuisineAndOccasion : NSObject
@property (readonly, nonatomic) NSString* occasion;
@property (readonly, nonatomic) NSString* cuisine;
-(instancetype)initWithOccasion:(NSString*)occasion cuisine:(NSString*)cuisine;
@end