//
//  Statement.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Statement : NSObject

@property NSString* text;
@property NSString* semanticId;

-(id)initWithText:(NSString*)text semanticId:(NSString*)semanticId;

@end
