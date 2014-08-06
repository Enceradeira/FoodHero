//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CuisineTableViewCell.h"

const UITableViewCellAccessoryType AccessoryTypeForChecked = UITableViewCellAccessoryCheckmark;
const UITableViewCellAccessoryType AccessoryTypeForNotChecked = UITableViewCellAccessoryNone;


@implementation CuisineTableViewCell {

    UILabel *_label;
    Cuisine *_cuisine;
}

- (void)awakeFromNib {
    _label = (UILabel *) [self viewWithTag:100];
    self.accessoryType = AccessoryTypeForNotChecked;
}

- (Cuisine *)cuisine {
    return _cuisine;
}

- (void)setCuisine:(Cuisine *)cuisine {
    _cuisine = cuisine;
    [self UpdateView];
}

- (BOOL)isSelected {
    return _cuisine.isSelected;
}

- (void)setIsSelected:(BOOL)isSelected {
    _cuisine.isSelected = isSelected;
    [self UpdateView];
}

- (void)UpdateView {
    _label.text = _cuisine.name;
    self.accessoryType = _cuisine.isSelected ? AccessoryTypeForChecked : AccessoryTypeForNotChecked;
}

@end