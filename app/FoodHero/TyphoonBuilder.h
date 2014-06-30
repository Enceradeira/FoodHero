//
//  JENTyphoonBuiler.h
//  HelloWorldApp
//
//  Created by Jorg on 11/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon.h>

@interface TyphoonBuilder : NSObject

+ (TyphoonComponentFactory*) createFactory:(TyphoonAssembly*) assembly;
+ (TyphoonStoryboard*) createStoryboard:(TyphoonComponentFactory*) factory;

@end
