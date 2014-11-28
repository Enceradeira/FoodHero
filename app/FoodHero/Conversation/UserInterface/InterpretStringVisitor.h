//
// Created by Jorg on 28/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpeechRecognitionVisitor.h"


@interface InterpretStringVisitor : SpeechRecognitionVisitor <IUActionVisitor>
+ (instancetype)create:(id <ISpeechRecognitionService>)service locationService:(LocationService *)locationService conversation:(Conversation *)conversation string:(NSString *)string;
@end