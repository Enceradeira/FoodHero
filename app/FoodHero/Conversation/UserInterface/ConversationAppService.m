//
//  ConversationAppService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <ReactiveCocoa.h>
#import "ConversationAppService.h"
#import "ConversationBubbleFoodHero.h"
#import "ConversationBubbleUser.h"
#import "Personas.h"
#import "SpeechInterpretation.h"
#import "UCuisinePreference.h"


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

        RACSignal *input = [speechRecognitionService.output map:^(SpeechInterpretation *interpretation) {
            if ([interpretation.intent isEqualToString:@"setFoodPreference"] && interpretation.entities.count == 1) {
                NSString *semanticId = [NSString stringWithFormat:@"U:CuisinePreference=%@", interpretation.entities[0]];
                TalkerUtterance *utterance = [UCuisinePreference createUtterance:interpretation.entities[0] text:interpretation.text];
                return utterance;
            }
            return [[TalkerUtterance alloc] initWithUtterance:@"????" customData:@[@"????"]];
        }];
        _conversation = [conversationRepository getForInput:input];
    }
    return self;
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
