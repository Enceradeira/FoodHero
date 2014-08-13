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
+ (instancetype)create:(Class)tokenClass image:(UIImage *)image choiceText:(NSString *)choiceText {
    return [[Feedback alloc] initWithTokenClass:tokenClass image:image choiceText:choiceText];
}

- (id)initWithTokenClass:(Class)tokenClass image:(UIImage *)image choiceText:(NSString *)choiceText {
    self = [super init];
    if (self != nil) {
        _tokenClass = tokenClass;
        _image = image;
        _choiceText = choiceText;
    }
    return self;
}

- (UIImage *)image {
    return _image;
}

- (ConversationToken *)createTokenFor:(Restaurant *)restaurant {
    return (ConversationToken *) [_tokenClass create:restaurant];
}
@end