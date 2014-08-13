//
// Created by Jorg on 06/08/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cuisine.h"


@interface CuisineTableViewCell : UITableViewCell
@property(nonatomic) Cuisine *cuisine;
@property(nonatomic) BOOL isSelected;
@end