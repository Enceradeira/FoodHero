//
// Created by Jorg on 05/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchException : NSException
+ (instancetype)createWithReason:(NSString *)reason1;
@end