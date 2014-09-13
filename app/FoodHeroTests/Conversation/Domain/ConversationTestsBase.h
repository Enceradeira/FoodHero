//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "Conversation.h"
#import "CLLocationManagerProxyStub.h"
#import "RestaurantSearchServiceStub.h"

@class RandomizerStub;
@class RestaurantRepository;

@interface ConversationTestsBase : XCTestCase

//@property(nonatomic, readonly) RestaurantSearchServiceStub *restaurantSearchStub;
@property(nonatomic, readonly) Conversation *conversation;
@property(nonatomic, readonly) CLLocationManagerProxyStub *locationManagerStub;
@property(nonatomic, readonly) RandomizerStub *tokenRandomizerStub;

- (void)configureRestaurantSearchForLatitude:(double)latitude longitude:(double)longitude configuration:(void (^)(RestaurantSearchServiceStub *))configuration;

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status;

- (void)expectedStatementIs:(NSString *)text userAction:(Class)action;

- (void)assertExpectedStatementsAtIndex:(NSUInteger)index;

- (void)assertLastStatementIs:(NSString *)semanticId userAction:(Class)userAction;

- (void)assertSecondLastStatementIs:(NSString *)semanticId userAction:(Class)userAction;
@end