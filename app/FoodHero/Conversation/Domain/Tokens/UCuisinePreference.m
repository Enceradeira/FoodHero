//
// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "UCuisinePreference.h"


@implementation UCuisinePreference {

}
+ (UCuisinePreference *)create:(NSString *)parameter {
    return [[UCuisinePreference alloc] initWithParameter:[NSString stringWithFormat:@"U:CuisinePreference=%@", parameter] parameter:parameter];
}
@end