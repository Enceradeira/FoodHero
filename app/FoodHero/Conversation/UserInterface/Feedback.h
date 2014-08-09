//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Feedback : NSObject
@property(nonatomic, readonly) NSString *text;

+ (instancetype)create:(NSString *)text image:(UIImage *)image;

- (id)initWithText:(NSString *)text image:(UIImage *)image;

- (UIImage *)image;
@end