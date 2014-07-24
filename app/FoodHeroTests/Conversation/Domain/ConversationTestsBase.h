//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "Conversation.h"
#import "CLLocationManagerProxyStub.h"
#import "RestaurantSearchServiceStub.h"

@class AlternationRandomizerStub;

@interface ConversationTestsBase : XCTestCase

@property(nonatomic, readonly) RestaurantSearchServiceStub *restaurantSearchStub;
@property(nonatomic, readonly) Conversation *conversation;
@property(nonatomic, readonly) CLLocationManagerProxyStub *locationManagerStub;
@property(nonatomic, readonly) AlternationRandomizerStub *tokenRandomizerStub;

- (void)restaurantSearchReturnsName:(NSString *)name vicinity:(NSString *)vicinity;

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status;

- (void)expectedStatementIs:(NSString *)text userAction:(Class)action;

- (void)assertExpectedStatementsAtIndex:(NSUInteger)index;

- (void)assertLastStatementIs:(NSString *)semanticId userAction:(Class)userAction;

- (void)assertSecondLastStatementIs:(NSString *)semanticId userAction:(Class)userAction;
@end