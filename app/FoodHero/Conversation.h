//
//  Conversation.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Statement.h"

@interface Conversation : NSObject

- (Statement *)getStatement:(NSInteger)index;

- (void)addStatement:(NSString *)statement;

- (NSInteger)getStatementCount;

@end
