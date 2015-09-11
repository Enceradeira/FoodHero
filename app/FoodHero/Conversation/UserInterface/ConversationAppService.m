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


static UIImage *LikeImage;
static UIImage *EmptyImage;


@implementation ConversationAppService {
    NSMutableDictionary *_bubbles;
    Conversation *_conversation;
    NSArray *_cuisines;
    NSArray *_feedbacks;
    LocationService *_locationService;
    id <IRestaurantRepository> _restaurantRepository;
    BOOL _doRenderSemanticID;
    id <ISpeechRecognitionService> _speechRecognitionService;
    NSString *_currState;
}


+ (void)initialize {
    [super initialize];
    LikeImage = [UIImage imageNamed:@"Like-Icon.png"];
    EmptyImage = [UIImage imageNamed:@"Empty-Icon.png"];
}

- (instancetype)initWithConversationRepository:(ConversationRepository *)conversationRepository
                          restaurantRepository:(id <IRestaurantRepository>)restaurantRepository
                               locationService:(LocationService *)locationService
                      speechRegocnitionService:(id <ISpeechRecognitionService>)speechRecognitionService {
    self = [super init];
    if (self != nil) {
        _doRenderSemanticID = NO;
        _bubbles = [NSMutableDictionary new];
        _locationService = locationService;
        _restaurantRepository = restaurantRepository;
        _speechRecognitionService = speechRecognitionService;

        RACSignal *input = [speechRecognitionService.output
                map:^(id output) {
                    if ([[output class] isSubclassOfClass:[NSError class]]) {
                        return output;
                    }
                    else {
                        SpeechInterpretation *interpretation = output;
                        NSArray *entities = interpretation.entities;
                        if ([interpretation.intent isEqualToString:@"CuisinePreference"]) {
                            if (entities.count == 0) {
                                return (id) [_speechRecognitionService userIntentUnclearError];
                            }

                            TextAndLocation *textAndLocation = [self convertToTextAndLocation:entities primaryEntityType:@"food_type"];
                            TalkerUtterance *utterance = [UserUtterances cuisinePreference:textAndLocation text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"DislikesOccasion"]) {
                            NSString *occasion = _conversation.currentOccasion;
                            if (occasion.length > 0) {
                                TalkerUtterance *utterance = [UserUtterances dislikesOccasion:interpretation.text occasion:occasion];
                                return (id) utterance;
                            }
                            else {
                                TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForDislike:[self getLastSuggestedRestaurant] text:interpretation.text];
                                return (id) utterance;
                            }
                        }
                        else if ([interpretation.intent containsString:@"OccasionPreference"]) {
                            if (entities.count == 0) {
                                return (id) [_speechRecognitionService userIntentUnclearError];
                            }

                            TextAndLocation *textAndLocation = [self convertToTextAndLocation:entities primaryEntityType:@"meal_type"];
                            TalkerUtterance *utterance = [UserUtterances occasionPreference:textAndLocation text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"SuggestionFeedback_Like"]) {
                            TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForLike:[self getLastSuggestedRestaurant] text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"SuggestionFeedback_LikeWithLocationRequest"]) {
                            TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForLikeWithLocationRequest:[self getLastSuggestedRestaurant] text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"SuggestionFeedback_Dislike"]) {
                            TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForDislike:[self getLastSuggestedRestaurant] text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"SuggestionFeedback_tooCheap"]) {
                            TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForTooCheap:[self getLastSuggestedRestaurant] text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"SuggestionFeedback_tooExpensive"]) {
                            TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForTooExpensive:[self getLastSuggestedRestaurant] text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"SuggestionFeedback_tooFarAway"]) {
                            TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForTooFarAway:[self getLastSuggestedRestaurant] text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"SuggestionFeedback_theClosestNow"]) {
                            TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForTheClosestNow:[self getLastSuggestedRestaurant] text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"GoodBye"]) {
                            TalkerUtterance *utterance = [UserUtterances goodBye:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"WantsToSearchForAnotherRestaurant"]) {
                            TalkerUtterance *utterance = [UserUtterances wantsToSearchForAnotherRestaurant:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"TryAgainNow"]) {
                            TalkerUtterance *utterance = [UserUtterances tryAgainNow:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"WantsToAbort"]) {
                            TalkerUtterance *utterance = [UserUtterances wantsToAbort:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"WantsToStartAgain"]) {
                            TalkerUtterance *utterance = [UserUtterances wantsToStartAgain:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"SuggestionFeedback_DislikesKindOfFood"]) {
                            TalkerUtterance *utterance = [UserUtterances dislikesKindOfFood:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"WantsToStopConversation"]) {
                            TalkerUtterance *utterance = [UserUtterances wantsToStopConversation:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"Hello"]) {
                            TalkerUtterance *utterance = [UserUtterances hello:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"LocationRequest"]) {
                            TalkerUtterance *utterance = [UserUtterances locationRequest:interpretation.text];
                            return (id) utterance;
                        }
                        assert(false);
                    }
                }];
        _conversation = [conversationRepository getForInput:input];
        [_speechRecognitionService setThreadId:_conversation.id];

        // forward states to speech recognition
        [[_conversation.statementIndexes map:^(id index) {
            return [_conversation getStatement:[index unsignedIntegerValue]];
        }] subscribeNext:^(Statement *s) {
            if (s.state != nil && s.state.length > 0) {
                [_speechRecognitionService setState:s.state];
                _currState = s.state;
            }
        }
        ];
    }

    return self;
}

- (TextAndLocation *)convertToTextAndLocation:(NSArray *)entities primaryEntityType:(NSString *)primaryEntityType {
    NSString *cuisine = [[[entities linq_where:^(SpeechEntity *entity) {
        return (BOOL) ([entity.type isEqualToString:primaryEntityType]);
    }] linq_select:^(SpeechEntity *entity) {
        return entity.value;
    }] linq_firstOrNil];

    NSString *location = [[[entities linq_where:^(SpeechEntity *entity) {
        return (BOOL) ([entity.type isEqualToString:@"location"]);
    }] linq_select:^(SpeechEntity *entity) {
        return entity.value;
    }] linq_firstOrNil];

    return [[TextAndLocation alloc] initWithText:cuisine == nil ? @"" : cuisine location:location == nil ? @"" : location];
}

- (void)startConversationWithFeedbackRequest:(BOOL)isWithFeedbackRequest {
    [_conversation start];
}

- (Restaurant *)getLastSuggestedRestaurant {
    NSArray *restaurants = _conversation.suggestedRestaurantsInCurrentSearch;
    if (restaurants.count == 0) {
        @throw [DesignByContractException createWithReason:@"no restaurants have ever been suggested to user"];
    }
    return [restaurants linq_lastOrNil];
}


+ (UIImage *)emptyImage {
    return EmptyImage;
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
            bubble = [[ConversationBubbleFoodHero alloc] initWithStatement:statement width:bubbleWidth index:index doRenderSemanticID:_doRenderSemanticID];
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
        [_speechRecognitionService simulateNetworkError:YES];
        [_restaurantRepository simulateNetworkError:YES];
    }
    else if ([command isEqualToString:@"C:NO"]) {
        // network error
        [_speechRecognitionService simulateNetworkError:NO];
        [_restaurantRepository simulateNetworkError:NO];
    }
    else if ([command isEqualToString:@"C:SS"]) {
        // show semantic-id
        _doRenderSemanticID = YES;
    }
    else if ([command isEqualToString:@"C:BS"]) {
        // be slow
        ConversationScript.searchTimeout = 0.5;
        [_restaurantRepository simulateSlowResponse:YES];
    }
}

- (void)addUserText:(NSString *)string {
    [_speechRecognitionService interpretString:string];
}

- (AVAudioSessionRecordPermission)recordPermission {
    return [_speechRecognitionService recordPermission];
}

- (void)setStateSource:(id <ISpeechRecognitionStateSource>)source {
    _speechRecognitionService.stateSource = source;
}

- (id <ISpeechRecognitionStateSource>)getStateSource {
    return _speechRecognitionService.stateSource;
}

- (ConversationBubbleFoodHero *)lastRawSuggestion {
    Statement *statement = _conversation.lastRawSuggestion;
    if (statement != nil) {
        return [[ConversationBubbleFoodHero alloc] initWithStatement:statement width:0 index:0 doRenderSemanticID:false];
    }
    else {
        return nil;
    }
}

- (void)pauseConversation {
    // setup notification
    return;

    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];

    NSDateComponents *dateComps = [[NSDateComponents alloc] init];

    NSDate *itemDate = [NSDate date];

    UILocalNotification *localNotif = [[UILocalNotification alloc] init];

    localNotif.fireDate = [itemDate dateByAddingTimeInterval:5];

    localNotif.timeZone = [NSTimeZone defaultTimeZone];

    localNotif.alertBody = @"Food Hero has sent you a message";

    localNotif.soundName = UILocalNotificationDefaultSoundName;

    localNotif.applicationIconBadgeNumber = 1;

    NSDictionary *infoDict = @{@"Hello" : @"TestMessage"};

    localNotif.userInfo = infoDict;

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

- (void)resumeConversation {
    // purse notification (reason ????... message arrived?)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)requestUserFeedback {
}
@end
