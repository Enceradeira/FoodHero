//
// Created by Jorg on 16/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoogleURL : NSObject
+ (instancetype)create:(NSString *)url;

- (id)init:(NSString *)url;

- (NSString *)userFriendlyURL;
@end