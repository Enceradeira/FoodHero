//
// Created by Jorg on 19/10/14.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "OpeningHoursViewController.h"
#import "OpeningHour.h"
#import "FoodHeroFonts.h"
#import "FoodHero-Swift.h"


@implementation OpeningHoursViewController {
    NSArray *_hours;
}

- (CGSize)preferredContentSize {

    CGFloat width = 0;

    for (OpeningHour *openingHour in _hours) {
        BOOL isBold = openingHour.isToday;
        CGSize daySize = [self calculateWidthOfText:openingHour.day isBold:isBold];
        CGSize hoursSize = [self calculateWidthOfText:openingHour.hours isBold:isBold];
        NSInteger widthMarginToDay = 10;
        NSInteger widthDayToHours = 10;
        CGFloat somethingMore = 10;
        CGSize size = CGSizeMake(daySize.width + hoursSize.width + (2 * widthMarginToDay) + widthDayToHours + somethingMore, daySize.height);
        if (width < size.width) {
            width = size.width;
        }
    }
    return CGSizeMake(width, [self tableView].rowHeight * _hours.count );
}

- (void)viewDidAppear:(BOOL)animated {
    [GAIService logScreenViewed:@"Opening Hours"];
}

- (CGSize)calculateWidthOfText:(NSString *)text isBold:(BOOL)isBold {
    UIFont *font = [FoodHeroFonts fontOfSize:isBold];
    NSDictionary *textAttributes = @{NSFontAttributeName : font};
    enum NSStringDrawingOptions textDrawingOptions = NSStringDrawingUsesLineFragmentOrigin;
    CGRect textSize = [text boundingRectWithSize:self.view.frame.size options:textDrawingOptions attributes:textAttributes context:nil];
    return textSize.size;
}

- (void)setOpeningHours:(NSArray *)hours {
    _hours = hours;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_hours count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OpeningHour *hour = (OpeningHour *) _hours[(NSUInteger) indexPath.row];
    UIFont *font = [FoodHeroFonts fontOfSize:hour.isToday];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpeningHourEntry"];

    UILabel *day = (UILabel *) [cell viewWithTag:100];
    day.text = hour.day;
    day.font = font;


    UILabel *hours = (UILabel *) [cell viewWithTag:101];
    hours.text = hour.hours;
    hours.font = font;
    return cell;
}

@end