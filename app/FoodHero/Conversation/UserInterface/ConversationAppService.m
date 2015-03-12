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
#import "SpeechInterpretation.h"
#import "DesignByContractException.h"
#import "FoodHero-Swift.h"


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
                map:^(SpeechInterpretation *interpretation) {
                    if ([interpretation.intent isEqualToString:@"setFoodPreference"] && interpretation.entities.count == 1) {
                        TalkerUtterance *utterance = [UserUtterances cuisinePreference:interpretation.entities[0] text:interpretation.text];
                        return utterance;
                    }
                    else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_Like"]) {
                        TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForLiking:[self getLastSuggestedRestaurant]currentUserLocation:[_locationService lastKnownLocation] text:interpretation.text];
                        return utterance;
                    }
                    else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_Dislike"]) {
                        TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForNotLikingAtAll:[self getLastSuggestedRestaurant] currentUserLocation:[_locationService lastKnownLocation] text:interpretation.text];
                        return utterance;
                    }
                    else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooCheap"]) {
                        TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForTooCheap:[self getLastSuggestedRestaurant] currentUserLocation:[_locationService lastKnownLocation] text:interpretation.text];
                        return utterance;
                    }
                    else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooExpensive"]) {
                        TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForTooExpensive:[self getLastSuggestedRestaurant] currentUserLocation:[_locationService lastKnownLocation] text:interpretation.text];
                        return utterance;
                    }
                    else if ([interpretation.intent isEqualToString:@"setSuggestionFeedback_tooFarAway"]) {
                        TalkerUtterance *utterance = [UserUtterances suggestionFeedbackForTooFarAway:[self getLastSuggestedRestaurant] currentUserLocation:[_locationService lastKnownLocation] text:interpretation.text];
                        return utterance;
                    }
                    else if ([interpretation.intent isEqualToString:@"goodBye"]) {
                        TalkerUtterance *utterance = [UserUtterances goodBye:interpretation.text];
                        return utterance;
                    }
                    else if ([interpretation.intent isEqualToString:@"searchForAnotherRestaurant"]) {
                        TalkerUtterance *utterance = [UserUtterances wantsToSearchForAnotherRestaurant:interpretation.text];
                        return utterance;
                    }
                    else if ([interpretation.intent isEqualToString:@"tryAgainNow"]) {
                        TalkerUtterance *utterance = [UserUtterances tryAgainNow:interpretation.text];
                        return utterance;
                    }
                    else if ([interpretation.intent isEqualToString:@"abort"]) {
                        TalkerUtterance *utterance = [UserUtterances wantsToAbort:interpretation.text];
                        return utterance;
                    }
                    assert(false);
                }];
        _conversation = [conversationRepository getForInput:input];
    }
    return self;
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

- (void)addUserText:(NSString *)string forState:(NSString *)state {
    [_speechRecognitionService interpretString:string state:state];

    /*
    InterpretStringVisitor *visitor = [InterpretStringVisitor create:_speechRecognitionService
                                                     locationService:_locationService
                                                        conversation:_conversation
                                                              string:string];
    [state accept:visitor];*/
}

- (void)addUserVoiceForState:(NSString *)state {
    [_speechRecognitionService recordAndInterpretUserVoice:state];

    /*
    RecordAndInterpretUserVoiceVisitor *visitor = [RecordAndInterpretUserVoiceVisitor create:_speechRecognitionService
                                                                             locationService:_locationService
                                                                                conversation:_conversation];
    [state accept:visitor];
    return visitor.signal;*/
}

- (AVAudioSessionRecordPermission)recordPermission {
    return [_speechRecognitionService recordPermission];
}
@end
