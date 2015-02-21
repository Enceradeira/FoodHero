//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "SearchAction.h"
#import "FoodHero-Swift.h"


@implementation UCuisinePreference {

}

+ (instancetype)create:(NSString *)parameter text:(NSString *)text {
    return [[UCuisinePreference alloc] initWithSemanticId:[NSString stringWithFormat:@"U:CuisinePreference=%@", parameter] text:text];
}

+ (TalkerUtterance*)createUtterance:(NSString *)parameter text:(NSString *)text {
    NSString *semanticId = [NSString stringWithFormat:@"U:CuisinePreference=%@", parameter];
    ConversationContext *context = [[ConversationContext alloc] initWithSemanticId:semanticId state:nil];
    return [[TalkerUtterance alloc] initWithUtterance:text customData:context];
}


@end