//
// Created by Jorg on 19/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "Conversation.h"
#import "CLLocationManagerProxyStub.h"
#import "RestaurantSearchServiceStub.h"
#import "FoodHero-Swift.h"
#import "EnvironmentStub.h"
#import "RestaurantRepository.h"

@class PlacesAPIStub;

@interface ConversationTestsBase : XCTestCase

@property(nonatomic, readonly) PlacesAPIStub *restaurantSearchStub;
@property(nonatomic, readonly) Conversation *conversation;
@property(nonatomic, readonly) CLLocationManagerProxyStub *locationManagerStub;
@property(nonatomic, readonly) TalkerRandomizerFake *talkerRandomizerFake;
@property(nonatomic, readonly) EnvironmentStub *environmentStub;
@property(nonatomic, readonly) RestaurantRepository *restaurantRepository;

- (void)resetConversationWhenIsWithFeedbackRequest:(BOOL)isWithFeedbackRequest;

- (void)codeAndDecodeWhenIsWithFeedbackRequest:(BOOL)isWithFeedbackRequest;

- (void)sendInput:(id)token;

- (void)configureRestaurantSearchForLatitude:(double)latitude longitude:(double)longitude configuration:(void (^)(PlacesAPIStub *))configuration;

- (void)resetRepositoryCache;

- (void)configureRestaurantSearchForLocation:(CLLocation *)location configuration:(void (^)(PlacesAPIStub *))configuration;

- (void)userSetsLocationAuthorizationStatus:(CLAuthorizationStatus)status;

- (void)expectedStatementIs:(NSString *)text userAction:(Class)action;

- (void)assertExpectedStatementsAtIndex:(NSUInteger)index;

- (void)assertLastStatementIs:(NSString *)semanticId state:(NSString *)state;

- (void)assertSecondLastStatementIs:(NSString *)semanticId state:(NSString *)state;

- (void)asynch:(void (^)())handler;

- (Statement *)getLastStatement;
@end