//
//  JENTyphoonBuiler.m
//  HelloWorldApp
//
//  Created by Jorg on 11/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import "TyphoonBuilder.h"

@implementation TyphoonBuilder
+ (TyphoonComponentFactory*) createFactory:(TyphoonAssembly*) assembly
{
    return [[TyphoonBlockComponentFactory alloc] initWithAssemblies:@[assembly]];
}
+ (TyphoonStoryboard*) createStoryboardFromFactory:(TyphoonComponentFactory*) factory{
    NSString *storyboardName = @"Main";
    return [TyphoonStoryboard storyboardWithName:storyboardName factory:factory bundle:nil];
}
+ (TyphoonStoryboard *)createStoryboardFromAssembly:(TyphoonAssembly *)assembly
{
    TyphoonComponentFactory* factory = [TyphoonBuilder createFactory:assembly];
    TyphoonStoryboard *storyboard = [TyphoonBuilder createStoryboardFromFactory:factory];
    return storyboard;
}
@end
