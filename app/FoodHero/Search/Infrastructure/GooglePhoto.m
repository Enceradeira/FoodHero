//
// Created by Jorg on 07/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "GooglePhoto.h"
#import "GoogleDefinitions.h"

@implementation GooglePhoto {
    NSString *_photoReference;
    NSUInteger _originalHeight;
    NSUInteger _originalWidth;
}
- (NSString *)url {
   return [NSString stringWithFormat:@"%@/maps/api/place/photo?photoreference=%@&maxheight=%u&maxwidth=%u&key=%@", GOOGLE_BASE_ADDRESS, _photoReference, _originalHeight, _originalWidth, GOOGLE_API_KEY];
}

- (id)init:(NSString *)reference height:(NSUInteger)height width:(NSUInteger)width {
    self = [super init];
    if (self != nil) {
        _photoReference = reference;
        _originalHeight = height;
        _originalWidth = width;
    }
    return self;
}

+ (instancetype)create:(NSString *)photoReference height:(NSUInteger)height width:(NSUInteger)width {
    return [[GooglePhoto alloc] init:photoReference height:height width:width];
}
@end
