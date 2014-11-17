//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"
#import "SearchAction.h"


@implementation UCuisinePreference {

}
- (id <ConversationAction>)createAction {
    return [SearchAction new];
}

+ (instancetype)create:(NSString *)parameter text:(NSString *)text {
    return [[UCuisinePreference alloc] initWithSemanticId:[NSString stringWithFormat:@"U:CuisinePreference=%@", parameter] text:text];
}

@end