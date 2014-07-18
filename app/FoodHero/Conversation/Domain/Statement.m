//
//  Statement.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "Statement.h"
#import "UAction.h"

@implementation Statement {
    id <UAction> _inputAction;
}
- (id)initWithText:(NSString *)text semanticId:(NSString *)semanticId persona:(Persona *)persona inputAction:(id <UAction>)inputAction {
    self = [super init];
    if (self != nil) {
        _text = text;
        _semanticId = semanticId;
        _persona = persona;
        _inputAction = inputAction;
    }
    return self;
}

- (id <UAction>)inputAction {
    return _inputAction;
}
@end
