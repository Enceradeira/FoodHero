//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CuisineTableViewCell.h"

static UIImage *UncheckedImage;
static UIImage *CheckedImage;

@implementation CuisineTableViewCell {

    UILabel *_label;
    Cuisine *_cuisine;
}

+ (void)initialize {
    UncheckedImage = [UIImage imageNamed:@"Checkmark-Unchecked.png"];
    CheckedImage = [UIImage imageNamed:@"Checkmark-Checked.png"];
}

- (void)awakeFromNib {
    _label = (UILabel *) [self viewWithTag:100];
    self.imageView.image = UncheckedImage;
    [self setIsAccessibilityElement:YES];
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
    self.imageView.image = _cuisine.isSelected ? CheckedImage : UncheckedImage;

    self.accessibilityLabel = _cuisine.name;
    self.accessibilityIdentifier = [NSString stringWithFormat:@"CuisineEntry=%@", _cuisine.name];
}

@end