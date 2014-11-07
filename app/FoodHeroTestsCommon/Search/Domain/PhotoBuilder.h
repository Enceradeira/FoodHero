//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPhoto;


@interface PhotoBuilder : NSObject
- (id <IPhoto>)build;

- (instancetype)withImage:(UIImage *)image;

@end