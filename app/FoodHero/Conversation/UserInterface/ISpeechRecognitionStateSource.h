//
// Created by Jorg on 20/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISpeechRecognitionStateSource <NSObject>
- (NSString *)getState;
@end