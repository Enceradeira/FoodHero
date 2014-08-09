//
// Created by Jorg on 09/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "AccessibilityHelper.h"


@implementation AccessibilityHelper {

}
+ (NSString *)sanitizeForIdentifier:(NSString *)identifier {
    NSString *sanitizedName = [identifier stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return sanitizedName;
}
@end