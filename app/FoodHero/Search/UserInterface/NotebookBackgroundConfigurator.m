//
// Created by Jorg on 09/11/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "NotebookBackgroundConfigurator.h"
#import "FoodHeroColors.h"


@implementation NotebookBackgroundConfigurator {

}
+ (void)configure:(UIView *)view {
    view.backgroundColor = [FoodHeroColors yellowColor];

    // _notebookPage with drop-shadow
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(3.0f, 2.0f);
    view.layer.shadowOpacity = 0.3f;

    // _notebookPage with round corners
    view.layer.cornerRadius = 8.0f;
}

@end