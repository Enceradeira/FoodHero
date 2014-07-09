//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Restaurant : NSObject
@property(nonatomic, readonly) NSString *vicinity;

@property(nonatomic, readonly) NSString *name;

@property(nonatomic, readonly) NSArray *types;

+ (Restaurant *)createWithName:(NSString *)name withVicinity:(NSString *)vicinity withTypes:(NSArray *)types;
@end