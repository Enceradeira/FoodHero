//
//  JENTyphoonBuiler.h
//  HelloWorldApp
//
//  Created by Jorg on 11/06/2014.
//  Copyright (c) 2014 co.uk.jennius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon.h>
#import "ConversationViewController.h"

@interface TyphoonBuilder : NSObject
+ (TyphoonComponentFactory*) createFactory:(TyphoonAssembly*) assembly;
+ (TyphoonStoryboard*) createStoryboardFromFactory:(TyphoonComponentFactory*) factory;
+ (TyphoonStoryboard *)createStoryboardFromAssembly:(TyphoonAssembly *)assembly;
@end
