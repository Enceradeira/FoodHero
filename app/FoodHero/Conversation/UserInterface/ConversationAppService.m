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
#import "FoodHero-Swift.h"
#import "SpeechInterpretation.h"


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

        RACSignal *input = [speechRecognitionService.output
                map:^(id output) {
                    if ([[output class] isSubclassOfClass:[NSError class]]) {
                        return output;
                    }
                    else {
                        SpeechInterpretation *interpretation = output;
                        if ([interpretation.intent isEqualToString:@"CuisinePreference"]) {
                            TalkerUtterance *utterance = [UserUtterances cuisinePreference:interpretation.entities[0] text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"DislikesOccasion"]) {
                            TalkerUtterance *utterance = [UserUtterances dislikesOccasion:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent containsString:@"OccasionPreference"]) {
                            NSArray *parts = [interpretation.intent componentsSeparatedByString:@"_"];
                            assert(parts.count == 2);
                            NSString *occasion = parts[1];
                            TalkerUtterance *utterance = [UserUtterances occasionPreference:[occasion lowercaseString] text:interpretation.text];
                            return (id) utterance;
                        }
                        else if ([interpretation.intent isEqualToString:@"SuggestionFeedback_Like"]) {
                            TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForLike:[self getLastSuggestedRestaurant] text:interpretation.text];
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
                        assert(false);
                    }
                }];
        _conversation = [conversationRepository getForInput:input];
    }
    return self;
}

- (void)startConversation {
    [_conversation start];
}

- (Restaurant *)getLastSuggestedRestaurant {
    NSArray *restaurants = _conversation.suggestedRestaurants;
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

@end
