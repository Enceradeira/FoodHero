//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TyphoonComponents.h"
#import "DesignByContractException.h"


id <ApplicationAssembly> _assembly;
TyphoonComponentFactory *_factory;
TyphoonStoryboard *_storyboard;

@implementation TyphoonComponents {

}
+ (void)reset {
    _assembly = nil;
    _factory = nil;
    _storyboard = nil;
}

+ (void)configure:(id <ApplicationAssembly>)assembly {
    [self reset];
    _assembly = assembly;
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
    _storyboard = [self createStoryboardFromAssembly:_assembly];
    return _storyboard;
}

+ (TyphoonComponentFactory *)createFactory:(id <ApplicationAssembly>)assembly {
    return [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[assembly]];
}

+ (TyphoonStoryboard *)createStoryboardFromFactory:(TyphoonComponentFactory *)factory {
    NSString *storyboardName = @"Main";
    return [TyphoonStoryboard storyboardWithName:storyboardName factory:factory bundle:nil];
}

+ (TyphoonStoryboard *)createStoryboardFromAssembly:(id <ApplicationAssembly>)assembly {
    TyphoonComponentFactory *factory = [self createFactory:assembly];
    TyphoonStoryboard *storyboard = [self createStoryboardFromFactory:factory];
    return storyboard;
}

+ (void)ensureAssembly {
    if (_assembly == nil) {
        @throw [[DesignByContractException alloc] initWithReason:@"no assembly configured"];
    }
}

@end