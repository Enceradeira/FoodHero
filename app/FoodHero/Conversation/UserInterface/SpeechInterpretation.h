//
// Created by Jorg on 16/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SpeechInterpretation : NSObject
@property double confidence;
@property NSString *text;
@property NSString *intent;
@property NSArray *entities;
@end