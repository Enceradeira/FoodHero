//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "Conversation.h"
#import "CLLocationManagerProxyStub.h"
#import "RestaurantSearchServiceStub.h"

@interface ConversationTestsBase : XCTestCase

@property(nonatomic, readonly) RestaurantSearchServiceStub *restaurantSearchStub;
@property(nonatomic, readonly) Conversation *conversation;
@property(nonatomic, readonly) CLLocationManagerProxyStub *locationManagerStub;

- (void)restaurantSearchReturnsName:(NSString *)name vicinity:(NSString *)vicinity;

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status;

- (void)expectedStatementIs:(NSString *)text userAction:(Class)action;

- (void)assertExpectedStatementsAtIndex:(NSUInteger)index;
@end