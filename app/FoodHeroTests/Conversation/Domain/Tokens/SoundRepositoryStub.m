//
// Created by Jorg on 14/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "SoundRepositoryStub.h"


@implementation SoundRepositoryStub {

}
- (Sound *)getNespressoSound {
    // make sound of length 0 in order that we don't have to wait for it
    return [Sound create:@"nespresso-16.6s" type:@"wav" length:0.0f];
}
@end