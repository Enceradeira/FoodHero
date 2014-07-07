//
//  Statement.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Statement.h"

@implementation Statement
-(id)initWithText:(NSString*)text semanticId:(NSString*)semanticId persona:(Persona*)persona;
{
    self = [super init];
    if( self != nil)
    {
        self.text = text;
        self.semanticId = semanticId;
        self.persona = persona;
    }
    return self;
}
@end
