//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "ConversationToken.h"


@interface Feedback : NSObject
@property(nonatomic, readonly) NSString *text;

+ (instancetype)create:(Class)tokenClass image:(UIImage *)image;

- (id)initWithTokenClass:(Class)tokenClass image:(UIImage *)image;

- (UIImage *)image;

- (ConversationToken *)createTokenFor:(Restaurant *)restaurant;
@end