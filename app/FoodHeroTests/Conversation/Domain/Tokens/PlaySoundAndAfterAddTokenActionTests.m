//
//  PlaySoundAndAfterAddTokenActionTests.m
//  FoodHero
//
//  Created by Jorg on 14/09/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <XCTestCase+AsyncTesting.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "PlaySoundAndAfterAddTokenAction.h"
#import "FHOpeningQuestion.h"
#import "ConversationSourceSpy.h"
#import "SoundRepositoryStub.h"

@interface PlaySoundAndAfterAddTokenActionTests : XCTestCase <PlaySoundAndAfterAddTokenActionDelegate>

@end

@implementation PlaySoundAndAfterAddTokenActionTests {
    PlaySoundAndAfterAddTokenAction *_action;
}

- (void)setUp {
    [super setUp];


    Sound *sound = [[SoundRepositoryStub new] getNespressoSound];
    _action = [PlaySoundAndAfterAddTokenAction create:[FHOpeningQuestion new]
                                                sound:sound];
    _action.delegate = self;
}


- (void)test_execute_ShouldAddTokenAfterSoundHasFinished {
    ConversationSourceSpy *conversationSource = [ConversationSourceSpy new];

    [_action execute:conversationSource];
    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];

    id addedToken = [conversationSource.tokens linq_firstOrNil];
    assertThat(addedToken, is(notNilValue()));
}

- (void)soundDidFinish {
    [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
}


@end
