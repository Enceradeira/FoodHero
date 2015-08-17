//
//  AudioSessionTests.m
//  FoodHero
//
//  Created by Jorg on 17/08/15.
//  Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AudioSession.h"

@interface AudioSessionTests : XCTestCase

@end

@implementation AudioSessionTests {
    AudioSession *_audioSession;
}

- (void)setUp {
    [super setUp];

    _audioSession = [[AudioSession alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_playJblBeginSound_ShouldPlayAudibleSound {
    [_audioSession playJblBeginSound]; // no crash is ok
}

- (void)test_playJblCancelSound_ShouldPlayAudibleSound {
    [_audioSession playJblCancelSound]; // no crash is ok
}


@end
