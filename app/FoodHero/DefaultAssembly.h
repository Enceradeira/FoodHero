//
//  JENAppAssembly.h
//  HelloWorldApp
//
//  Created by Jorg on 10/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import "TyphoonAssembly.h"
#include "ApplicationAssembly.h"

@interface DefaultAssembly : TyphoonAssembly <ApplicationAssembly>
- (id)navigationViewController;

- (id)conversationViewController;

- (id)conversationAppService;

- (id)conversationRepository;

- (id)restaurantSearch;

- (id)conversation;
@end
