//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Restaurant : NSObject
@property(nonatomic, readonly) NSString *vicinity;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSArray *types;
@property(nonatomic, readonly) NSString *placeId;

+ (Restaurant *)createWithName:(NSString *)name vicinity:(NSString *)vicinity types:(NSArray *)types placeId:(id)placeId;
@end