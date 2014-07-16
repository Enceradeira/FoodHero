//
// Created by Jorg on 16/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHSuggestion.h"


@implementation FHSuggestion {

}
+ (ConversationToken *)create:(NSString *)nameAndPlace {

    NSString *text = [[NSString alloc] initWithFormat:@"Maybe you like the '%@'?", nameAndPlace];
    NSString *sanitizedName = [nameAndPlace stringByReplacingOccurrencesOfString:@"'" withString:@""];

    return [[FHSuggestion alloc] initWithParameter:[NSString stringWithFormat:@"FH:Suggestion=%@", sanitizedName] parameter:text];
}
@end