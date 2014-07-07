//
//  JENAppAssembly.h
//  HelloWorldApp
//
//  Created by Jorg on 10/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import "TyphoonAssembly.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
@protocol ApplicationAssembly
- (id)navigationViewController;

- (id)conversationViewController;

- (id)conversationAppService;

- (id)conversationRepository;
@end

@interface ApplicationAssembly : TyphoonAssembly <ApplicationAssembly>
@end

#pragma clang diagnostic pop