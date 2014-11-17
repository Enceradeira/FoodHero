//
// Created by Jorg on 17/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NoSpeechInterpretationError : NSError
+ (NSError *)create:(NSError *)error;
@end