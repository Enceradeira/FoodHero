//
// Created by Jorg on 25/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGoodByeAfterSuccess.h"
#import "TyphoonComponents.h"
#import "TextRepository.h"


@implementation FHGoodByeAfterSuccess {

}
- (instancetype)init {
    TextRepository *textRepository = [(id <ApplicationAssembly>) [TyphoonComponents factory] textRepository];
    NSString *text = [textRepository getGoodByeAfterSuccess];
    self = [super initWithSemanticId:@"FH:GoodByeAfterSuccess" text:text];
    return self;
}


@end