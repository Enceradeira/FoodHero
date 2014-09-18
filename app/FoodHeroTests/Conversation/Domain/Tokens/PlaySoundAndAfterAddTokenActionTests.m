//
//  PlaySoundAndAfterAddTokenActionTests.m
//  FoodHero
//
//  Created by Jorg on 14/09/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "PlaySoundAndAfterAddTokenAction.h"
#import "FHOpeningQuestion.h"
#import "ConversationSourceSpy.h"
#import "StubAssembly.h"
#import "TyphoonComponents.h"

@interface PlaySoundAndAfterAddTokenActionTests : XCTestCase

@end

@implementation PlaySoundAndAfterAddTokenActionTests {
    PlaySoundAndAfterAddTokenAction *_action;
}

- (void)setUp {
    [super setUp];

    [TyphoonComponents configure:[StubAssembly new]];

    _action = [PlaySoundAndAfterAddTokenAction create:[FHOpeningQuestion new]
                                                sound:[Sound new]];
}


- (void)test_execute_ShouldAddTokenAfterSoundHasFinished {
    ConversationSourceSpy *conversationSource = [ConversationSourceSpy new];

    [_action execute:conversationSource];

    id addedToken = [conversationSource.tokens linq_firstOrNil];
    assertThat(addedToken, is(notNilValue()));
}

@end
