//
// Created by Jorg on 08/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Feedback.h"
#import "USuggestionFeedbackForLiking.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"


@implementation Feedback {
    UIImage *_image;
    Class _tokenClass;
}
+ (instancetype)create:(Class)tokenClass image:(UIImage *)image {
    return [[Feedback alloc] initWithTokenClass:tokenClass image:image];
}

- (id)initWithTokenClass:(Class)tokenClass image:(UIImage *)image {
    self = [super init];
    if (self != nil) {
        _tokenClass = tokenClass;
        _image = image;
    }
    return self;
}

- (NSString *)text {
    return [self createTokenFor:nil].parameter;
}

- (UIImage *)image {
    return _image;
}

- (ConversationToken *)createTokenFor:(Restaurant *)restaurant {
    return (ConversationToken *) [_tokenClass create:restaurant];
}
@end