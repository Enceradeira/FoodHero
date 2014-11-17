//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@protocol ISpeechRecognitionService <NSObject>
- (RACSignal *)interpretString:(NSString *)string customData:(id)customData;
@end