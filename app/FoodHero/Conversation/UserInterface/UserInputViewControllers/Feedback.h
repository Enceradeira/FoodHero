//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
#import "ConversationToken.h"


@interface Feedback : NSObject
@property(nonatomic, readonly) NSString *choiceText;

@property(nonatomic, readonly) Class tokenClass;

+ (instancetype)create:(Class)tokenClass image:(UIImage *)image choiceText:(NSString *)choiceText;

- (id)initWithTokenClass:(Class)tokenClass image:(UIImage *)image choiceText:(NSString *)choiceText;

- (UIImage *)image;

- (ConversationToken *)createTokenFor:(Restaurant *)restaurant;
@end