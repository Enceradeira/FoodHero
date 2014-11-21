//
//  ConversationAppService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "ConversationAppService.h"
#import "ConversationBubbleFoodHero.h"
#import "ConversationBubbleUser.h"
#import "Personas.h"
#import "DesignByContractException.h"
#import "SpeechInterpretation.h"
#import "UCuisinePreference.h"
#import "USuggestionFeedback.h"
#import "USuggestionFeedbackForTooFarAway.h"
#import "USuggestionFeedbackForTooExpensive.h"
#import "USuggestionFeedbackForTooCheap.h"
#import "USuggestionFeedbackForNotLikingAtAll.h"
#import "USuggestionFeedbackForLiking.h"

static UIImage *LikeImage;
static UIImage *EmptyImage;

@implementation ConversationAppService {
    NSMutableDictionary *_bubbles;
    Conversation *_conversation;
    NSArray *_cuisines;
    NSArray *_feedbacks;
    LocationService *_locationService;
    RestaurantRepository *_restaurantRepository;
    BOOL _doRenderSemanticID;
    NSTimeInterval _interactionDelay;
    id <ISpeechRecognitionService> _speechRecognitionService;
}


+ (void)initialize {
    [super initialize];
    LikeImage = [UIImage imageNamed:@"Like-Icon.png"];
    EmptyImage = [UIImage imageNamed:@"Empty-Icon.png"];
}

- (instancetype)initWithConversationRepository:(ConversationRepository *)conversationRepository
                          restaurantRepository:(RestaurantRepository *)restaurantRepository
                               locationService:(LocationService *)locationService
                      speechRegocnitionService:(id <ISpeechRecognitionService>)speechRecognitionService {
    self = [super init];
    if (self != nil) {
        _doRenderSemanticID = NO;
        _bubbles = [NSMutableDictionary new];
        _locationService = locationService;
        _restaurantRepository = restaurantRepository;
        _speechRecognitionService = speechRecognitionService;
        _conversation = conversationRepository.get;
    }
    return self;
}

+ (UIImage *)emptyImage {
    return EmptyImage;
}

- (void)addUserInput:(ConversationToken *)userInput {
    [_conversation addToken:userInput];
    // delays for integration testing
    [NSThread sleepForTimeInterval:_interactionDelay];
}

- (NSInteger)getStatementCount {
    return _conversation.getStatementCount;
}

- (ConversationBubble *)getStatement:(NSUInteger)index bubbleWidth:(CGFloat)bubbleWidth {

    NSString *key = [NSString stringWithFormat:@"%ld-%ld", (long) index, (long) bubbleWidth];
    ConversationBubble *bubble = _bubbles[key];
    if (bubble == nil) {
        Statement *statement = [_conversation getStatement:index];

        if (statement.persona == Personas.foodHero) {
            bubble = [[ConversationBubbleFoodHero alloc] initWithStatement:statement width:bubbleWidth index:index inputAction:statement.inputAction doRenderSemanticID:_doRenderSemanticID];
        }
        else {
            bubble = [[ConversationBubbleUser alloc] initWithStatement:statement width:bubbleWidth index:index doRenderSemanticID:_doRenderSemanticID];
        }

        _bubbles[key] = bubble;
    }
    return bubble;
}

- (RACSignal *)statementIndexes {
    return _conversation.statementIndexes;
}

- (Restaurant *)getLastSuggestedRestaurant {
    NSArray *restaurants = _conversation.suggestedRestaurants;
    if (restaurants.count == 0) {
        @throw [DesignByContractException createWithReason:@"no restaurants have ever been suggested to user"];
    }
    return [restaurants linq_lastOrNil];
}

- (void)processCheat:(NSString *)command {
    if ([command isEqualToString:@"C:FS"]) {
        // find something
        [_restaurantRepository simulateNoRestaurantFound:NO];
    }
    else if ([command isEqualToString:@"C:FN"]) {
        // find nothing
        [_restaurantRepository simulateNoRestaurantFound:YES];
    }
    else if ([command isEqualToString:@"C:NE"]) {
        // network error
        [_restaurantRepository simulateNetworkError:YES];
    }
    else if ([command isEqualToString:@"C:SS"]) {
        // show semantic-id
        _doRenderSemanticID = YES;
    }
    else if ([command isEqualToString:@"C:BS"]) {
        // be slow
        [_restaurantRepository simulateSlowResponse:YES];
    }

}

- (void)addUserCuisinePreference:(NSString *)string {
    RACSignal *signal = [_speechRecognitionService interpretString:string customData:nil];

    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        if ([interpretation.intent isEqualToString:@"setFoodPreference"] && interpretation.entities.count == 1) {
            [self addUserInput:[UCuisinePreference create:interpretation.entities[0] text:interpretation.text]];
        }
    }];
}

- (void)addUserSuggestionFeedback:(NSString *)string {
    RACSignal *signal = [_speechRecognitionService interpretString:string customData:nil];

    [signal subscribeNext:^(SpeechInterpretation *interpretation) {
        Restaurant *restaurant = [self getLastSuggestedRestaurant];
        if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooFarAway"]) {
            [self addUserInput:[USuggestionFeedbackForTooFarAway create:restaurant currentUserLocation:_locationService.lastKnownLocation text:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooExpensive"]) {
            [self addUserInput:[USuggestionFeedbackForTooExpensive create:restaurant text:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooCheap"]) {
            [self addUserInput:[USuggestionFeedbackForTooCheap create:restaurant text:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_Dislike"]) {
            [self addUserInput:[USuggestionFeedbackForNotLikingAtAll create:restaurant text:interpretation.text]];
        }
        else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_Like"]) {
            [self addUserInput:[USuggestionFeedbackForLiking create:restaurant text:interpretation.text]];
        }
    }];
}
@end
