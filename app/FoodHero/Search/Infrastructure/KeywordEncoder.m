//
// Created by Jorg on 12/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "KeywordEncoder.h"


@implementation KeywordEncoder {

}
+ (NSString *)encodeString:(NSString *)keyword {
    //return [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [[keyword
            stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
            stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
}

@end