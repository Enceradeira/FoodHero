//
// Created by Jorg on 09/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FoodHeroColors.h"


const float ColorDivisor = 255.0f;

@implementation FoodHeroColors {

}
+ (UIColor *)lightestBackgroundGrey {
    return [UIColor colorWithRed:247 / ColorDivisor green:247 / ColorDivisor blue:247 / ColorDivisor alpha:1];
}

+ (UIColor *)lightestDrawningGrey {
    return [UIColor colorWithRed:208 / ColorDivisor green:208 / ColorDivisor blue:208 / ColorDivisor alpha:1];
}

+ (UIColor *)darkerSepeartorGrey {
    return [UIColor colorWithRed:178 / ColorDivisor green:178 / ColorDivisor blue:178 / ColorDivisor alpha:1];
}

+ (UIColor *)actionColor {
    return [UIColor colorWithRed:144 / ColorDivisor green:32 / ColorDivisor blue:27 / ColorDivisor alpha:1];
}

+ (UIColor *)yellowColor {
    return [UIColor colorWithRed:232 / ColorDivisor green:209 / ColorDivisor blue:145 / ColorDivisor alpha:1];
}

+ (UIColor *)darkGrey {
    return [UIColor colorWithRed:61 / ColorDivisor green:61 / ColorDivisor blue:61 / ColorDivisor alpha:1];
}
@end