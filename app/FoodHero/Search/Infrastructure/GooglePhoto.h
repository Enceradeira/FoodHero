//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPhoto.h"


@interface GooglePhoto : NSObject <IPhoto>
+ (instancetype)create:(NSString *)photoReference height:(NSUInteger)height width:(NSUInteger)width;
@end
