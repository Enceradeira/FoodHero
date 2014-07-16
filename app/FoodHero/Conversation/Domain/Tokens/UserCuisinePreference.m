//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UserCuisinePreference.h"


@implementation UserCuisinePreference {

}
+ (UserCuisinePreference *)create:(NSString *)parameter {
    return [[UserCuisinePreference alloc] initWithParameter:[NSString stringWithFormat:@"U:CuisinePreference=%@", parameter] parameter:parameter];
}
@end