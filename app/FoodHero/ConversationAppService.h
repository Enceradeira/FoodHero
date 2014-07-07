//
//  ConversationAppService.h
//  FoodHero
//
//  Created by Jorg on 07/07/2014.
//  Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConversationBubble.h"

@interface ConversationAppService : NSObject
-(ConversationBubble*) getStatement:(NSInteger)index bubbleWidth:(CGFloat)bubbleWidth;
-(void) addStatement:(NSString*)statement;
@end
