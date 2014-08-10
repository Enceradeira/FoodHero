//
// Created by Jorg on 09/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FoodHeroColors.h"


const float _d = 255.0f;

@implementation FoodHeroColors {

}
+ (UIColor *)lightestBackgroundGrey {
    return [UIColor colorWithRed:247 / _d green:247 / _d blue:247 / _d alpha:1];
}

+ (UIColor *)lightestDrawningGrey {
    return [UIColor colorWithRed:208 / _d green:208 / _d blue:208 / _d alpha:1];
}

+ (UIColor *)darkerSepeartorGrey {
    return [UIColor colorWithRed:178 / _d green:178 / _d blue:178 / _d alpha:1];
}
@end