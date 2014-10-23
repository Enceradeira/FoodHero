//
// Created by Jorg on 22/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FoodHeroFonts.h"


@implementation FoodHeroFonts {

}
+ (UIFont *)fontOfSize:(BOOL)isBold {
    if (isBold) {
        return [UIFont boldSystemFontOfSize:13];
    }
    else {
        return [UIFont systemFontOfSize:13];
    }
}
@end