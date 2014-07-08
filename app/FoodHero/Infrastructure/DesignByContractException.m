//
//  DesignByContractException.m
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "DesignByContractException.h"

@implementation DesignByContractException
- (id)initWithReason:(NSString *)reason {
    self = [super initWithName:@"DesignByContractException" reason:reason userInfo:nil];
    return self;
}
@end
