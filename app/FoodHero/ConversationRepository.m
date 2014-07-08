//
//  ConcersationService.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "ConversationRepository.h"

@implementation ConversationRepository {
    Conversation *_onlyConversation;
    NSObject <RestaurantSearch> *_restaurantSearch;
}

- (id)initWithDependencies:(NSObject<RestaurantSearch>*) restaurantSearch
{
    self = [super init];
    if( self != nil ){
        _restaurantSearch = restaurantSearch;
    }
    return self;
}

- (Conversation *)get {
    if (_onlyConversation == nil) {
        _onlyConversation = [[Conversation alloc] initWithDependencies:_restaurantSearch];
    }
    return _onlyConversation;
}
@end
