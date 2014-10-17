//
// Created by Jorg on 16/10/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "GoogleURL.h"


@implementation GoogleURL {

    NSString *_url;
}
+ (instancetype)create:(NSString *)url {
    return [[GoogleURL alloc] init:url];
}

- (id)init:(NSString *)url {
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;

}

- (NSString *)userFriendlyURL {
    NSURL *url = [NSURL URLWithString:_url];
    if (!url.host || [_url rangeOfString:@"http://"].length == 0) {
        return _url;
    }
    NSString *path = @"";
    if (url.path.length > 1) {
        path = url.path;
    }


    NSString *host = [self trimBegin:@"www." from:url.host];
    return [NSString stringWithFormat:@"%@%@", host == nil ? @"" : host, path];
}

- (NSString *)trimBegin:(NSString *)text from:(NSString *)url {
    NSRange range = [url rangeOfString:text];
    if (range.location == 0) {
        url = [url substringFromIndex:range.length];
    }
    return url;
}
@end