//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SoundRepository.h"


@implementation SoundRepository {

}
- (Sound *)getNespressoSound {
    return [Sound create:@"nespresso-16.6s" type:@"wav" length:20.0f];
}

@end