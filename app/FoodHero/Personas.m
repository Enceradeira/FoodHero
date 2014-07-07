//
//  PersonaRepository.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Personas.h"
#import "FoodHero.h"
#import "AnonymousUser.h"

FoodHero *_foodHero;
AnonymousUser *_user;

@implementation Personas
+(Persona*) foodHero
{
    if (_foodHero==nil) {
        _foodHero = [FoodHero new];
    }
    return _foodHero;
}
+(Persona*) user
{
    if (_user==nil)
    {
        _user = [AnonymousUser new];
    }
    return _user;
}
@end
