//
//  JENAppAssembly.h
//  HelloWorldApp
//
//  Created by Jorg on 10/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import "TyphoonAssembly.h"

@protocol ApplicationAssembly
- (id) navigationViewController;
- (id) conversationViewController;
- (id) conversationAppService;
@end

@interface ApplicationAssembly : TyphoonAssembly<ApplicationAssembly>
@end
