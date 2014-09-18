//
//  SoundPlayerTests.m
//  FoodHero
//
//  Created by Jorg on 18/09/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XCAsyncTestCase/XCTestCase+AsyncTesting.h>
#import "SoundPlayer.h"

@interface SoundPlayerTests : XCTestCase <PlaySoundDelegate>

@end

@implementation SoundPlayerTests {
    SoundPlayer *_soundPlayer;
}

- (void)setUp {
    [super setUp];

    _soundPlayer = [SoundPlayer new];
}

- (void)tests_playSound_ShouldPlaySoundAndCallCallback {
    Sound *sound = [Sound create:@"nespresso-16.6s" type:@"wav" length:0.3f];

    [_soundPlayer play:sound delay:0.0];
    [_soundPlayer setDelegate:self];

    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];
}

- (void)soundDidFinish {
    [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
}

@end
