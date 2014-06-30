//
//  JENAppAssembly.m
//  HelloWorldApp
//
//  Created by Jorg on 10/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import "ApplicationAssembly.h"
#import "FoodHeroNavigationController.h"

@implementation ApplicationAssembly
- (id)helloWorldController
{
    return [TyphoonDefinition withClass:[FoodHeroNavigationController class]];
}
@end
