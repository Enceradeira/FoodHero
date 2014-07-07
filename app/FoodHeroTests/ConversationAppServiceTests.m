//
//  ConversationAppServiceTests.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Typhoon.h>
#import "TyphoonBuilder.h"
#import "ApplicationAssembly.h"
#import "ConversationAppService.h"

@interface ConversationAppServiceTests : XCTestCase

@end

@implementation ConversationAppServiceTests
{
    ConversationAppService* _service;
}
- (void)setUp
{
    [super setUp];
    
    TyphoonComponentFactory *factory = [TyphoonBuilder createFactory:[ApplicationAssembly new]];
    _service =  [(ApplicationAssembly*)factory conversationAppService ];
}

@end
