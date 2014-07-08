//
// Created by Jorg on 08/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TyphoonComponents.h"
#import "DesignByContractException.h"


id <ApplicationAssembly> _assembly;

@implementation TyphoonComponents {

}
+ (void)reset {
    _assembly = nil;
}

+ (void)configure:(id <ApplicationAssembly>)assembly {
    _assembly = assembly;
}

+ (TyphoonComponentFactory *)factory {
    [self ensureAssembly];
    return [self createFactory:_assembly];
}

+ (TyphoonStoryboard *)storyboard {
    [self ensureAssembly];
    return [self createStoryboardFromAssembly:_assembly];
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