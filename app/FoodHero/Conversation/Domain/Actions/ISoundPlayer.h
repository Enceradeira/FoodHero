//
// Created by Jorg on 18/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sound.h"
#import "PlaySoundDelegate.h"

@protocol ISoundPlayer <NSObject>
@property(nonatomic, weak) id <PlaySoundDelegate> delegate;

- (void)play:(Sound *)sound delay:(NSTimeInterval)delay;
@end