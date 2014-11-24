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
#import "RestaurantRepository.h"

@class AskUserIfProblemWithAccessLocationServiceResolved;

@interface ConversationAppService : NSObject

- (instancetype)initWithConversationRepository:(ConversationRepository *)conversationRepository
                          restaurantRepository:(RestaurantRepository *)restaurantRepository
                               locationService:(LocationService *)locationService
                      speechRegocnitionService:(id <ISpeechRecognitionService>)speechRecognitionService;

- (ConversationBubble *)getStatement:(NSUInteger)index bubbleWidth:(CGFloat)bubbleWidth;

+ (UIImage *)emptyImage;

- (RACSignal *)statementIndexes;

- (void)processCheat:(NSString *)command;

- (NSInteger)getStatementCount;

- (void)addUserText:(NSString *)string forInputAction:(id <IUAction>)inputAction;

- (RACSignal *)addUserVoiceForInputAction:(id <IUAction>)inputAction;
@end
