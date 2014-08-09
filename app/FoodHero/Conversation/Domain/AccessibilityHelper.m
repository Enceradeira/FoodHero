//
// Created by Jorg on 09/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AccessibilityHelper.h"


@implementation AccessibilityHelper {

}
+ (NSString *)sanitizeForLabel:(NSString *)label {
    NSString *sanitizedName = [label stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return sanitizedName;
}
@end