//
//  ConversationAppService.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationBubble.h"
#import "ConversationRepository.h"
#import "LocationService.h"
#import "ISpeechRecognitionService.h"

@class RACSignal;
@class ConversationToken;
@class Cuisine;
@class Feedback;
@class RestaurantRepository;

@interface ConversationAppService : NSObject

- (instancetype)initWithConversationRepository:(ConversationRepository *)conversationRepository
                          restaurantRepository:(RestaurantRepository *)restaurantRepository
                               locationService:(LocationService *)locationService
                      speechRegocnitionService:(id <ISpeechRecognitionService>)speechRecognitionService;

- (ConversationBubble *)getStatement:(NSUInteger)index bubbleWidth:(CGFloat)bubbleWidth;

+ (UIImage *)emptyImage;

- (RACSignal *)statementIndexes;

- (void)addUserInput:(ConversationToken *)userInput;

- (void)addUserFeedbackForLastSuggestedRestaurant:(Feedback *)feedback;

- (void)processCheat:(NSString *)command;

- (NSInteger)getStatementCount;

- (NSInteger)getCuisineCount;

- (Cuisine *)getCuisine:(NSUInteger)index;

- (NSString *)getSelectedCuisineText;

- (NSInteger)getFeedbackCount;

- (Feedback *)getFeedback:(NSUInteger)index;

- (void)addUserCuisinePreference:(NSString *)string;
@end
