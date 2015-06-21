//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TyphoonComponents.h"
#import "DesignByContractException.h"


TyphoonAssembly *_assembly;
TyphoonComponentFactory *_factory;
TyphoonStoryboard *_storyboard;

@implementation TyphoonComponents {

}
+ (id<ApplicationAssembly>)getAssembly {
    [self ensureAssembly];
    return (id <ApplicationAssembly>) [[TyphoonComponents storyboard] factory];
}

+ (void)reset {
    _assembly = nil;
    _factory = nil;
    _storyboard = nil;
}

+ (void)configure:(TyphoonAssembly *)assembly {
    [self reset];
    _assembly = assembly;
    [[TyphoonAssemblyActivator withAssembly:assembly] activate];
}

+ (TyphoonComponentFactory *)factory {
    if (_factory != nil) {
        return _factory;
    }

    [self ensureAssembly];
    _factory = [self createFactory:_assembly];
    return _factory;
}

+ (TyphoonStoryboard *)storyboard {
    if (_storyboard != nil) {
        return _storyboard;
    }

    [self ensureAssembly];
    TyphoonStoryboard *storyboard = [[self class] createStoryboardFromFactory:[[self class] factory]];
    _storyboard = storyboard;
    return _storyboard;
}

+ (TyphoonComponentFactory *)createFactory:(TyphoonAssembly *)assembly {
    return [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[assembly]];
}

+ (TyphoonStoryboard *)createStoryboardFromFactory:(TyphoonComponentFactory *)factory {
    NSString *storyboardName = @"Main";
    return [TyphoonStoryboard storyboardWithName:storyboardName factory:factory bundle:nil];
}

+ (void)ensureAssembly {
    if (_assembly == nil) {
        @throw [[DesignByContractException alloc] initWithReason:@"no assembly configured"];
    }
}

@end