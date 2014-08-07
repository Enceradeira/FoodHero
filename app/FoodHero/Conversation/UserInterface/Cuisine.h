//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Cuisine : NSObject
@property(nonatomic) NSString *name;
@property(nonatomic) BOOL isSelected;
@property(nonatomic) NSDate *isSelectedTimeStamp;

+ (instancetype)create:(NSString *)name;

- (id)initWithName:(NSString *)name;
@end