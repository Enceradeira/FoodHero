//
//  ConversationAppService.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

@import AVFoundation;

#import <Foundation/Foundation.h>
#import "ConversationBubble.h"
#import "ConversationRepository.h"
#import "LocationService.h"
#import "ISpeechRecognitionService.h"
#import "IRestaurantRepository.h"

@class ConversationBubbleFoodHero;

@interface ConversationAppService : NSObject

@property(weak, nonatomic) id <ISpeechRecognitionStateSource> stateSource;

- (instancetype)initWithConversationRepository:(ConversationRepository *)conversationRepository
                          restaurantRepository:(id<IRestaurantRepository>)restaurantRepository
                               locationService:(LocationService *)locationService
                      speechRegocnitionService:(id <ISpeechRecognitionService>)speechRecognitionService;

- (ConversationBubble *)getStatement:(NSUInteger)index bubbleWidth:(CGFloat)bubbleWidth;

- (void)startConversation;

+ (UIImage *)emptyImage;

- (RACSignal *)statementIndexes;

- (void)processCheat:(NSString *)command;

- (NSInteger)getStatementCount;

- (void)addUserText:(NSString *)string;

- (AVAudioSessionRecordPermission)recordPermission;

- (ConversationBubbleFoodHero *)lastRawSuggestion;
@end
