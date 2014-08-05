//
// Created by Jorg on 05/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "CuisineCollectionViewCell.h"


@implementation CuisineCollectionViewCell {

    UILabel *_label;
}

- (void)awakeFromNib {
    _label = (UILabel *) [self viewWithTag:100];
}

- (void)setCuisine:(NSString *)cuisine {
    _label.text = cuisine;
}

- (NSString *)cuisine {
    return _label.text;
}
@end