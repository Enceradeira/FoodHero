//
//  Statement.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Persona.h"

@interface Statement : NSObject

@property NSString* text;
@property NSString* semanticId;
@property Persona* persona;

-(id)initWithText:(NSString*)text semanticId:(NSString*)semanticId persona:(Persona*)persona;

@end
