//
// Created by Jorg on 18/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "RestaurantRepositoryTests.h"
#import "GooglePlace.h"
#import "RACSignal.h"
#import "RestaurantRepository.h"
#import "DesignByContractException.h"
#import "CuisineAndOccasion.h"


@implementation RestaurantRepositoryTests {

}

- (NSArray *)getPlacesBy:(CuisineAndOccasion *)cuisine {
    return [[self.repository getPlacesBy:cuisine] toArray][0];
}

-(RestaurantRepository *)repository{
    @throw [DesignByContractException createWithReason:@"methode must be override by subclass"];
}

@end