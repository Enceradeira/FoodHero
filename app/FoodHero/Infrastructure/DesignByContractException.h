//
//  DesignByContractException.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignByContractException : NSException
- (id)initWithReason:(NSString *)reason;

+ (DesignByContractException *)createWithReason:(NSString *)reason;
@end
