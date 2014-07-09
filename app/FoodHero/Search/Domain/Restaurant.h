//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Restaurant : NSObject
@property(nonatomic) NSString *vicinity;

@property(nonatomic) NSString *name;

+ (Restaurant *)createWithName:(NSString *)name withVicinity:(NSString *)vicinity;
@end