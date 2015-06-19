//
// Created by Jorg on 12/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class SuggestionLikedPostingsController: UITableViewController {
    private var restaurant: Restaurant!

    public func setRestaurant(restaurant: Restaurant) {
        self.restaurant = restaurant

        iLikeRestaurantCell.textLabel!.text = "I like \(restaurant.name)"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sharedText = ""
        let selectedCell = cells.filter({ $0.row == indexPath.row }).first!
        switch (selectedCell.cell) {
        case anyoneJoiningMeCell:
            sharedText = SharingTextBuilder.anyoneJoiningMe(restaurant)
        case iLikeRestaurantCell:
            sharedText = SharingTextBuilder.iLikeRestaurant(restaurant)
        case iLikeFoodHeroCell:
            sharedText = SharingTextBuilder.foodHeroIsCool()
        case somethingElseCell:
            sharedText = "\n\n" + SharingTextBuilder.downloadFoodHero()
        default:
            assert(false, "cell not found")

        }

        let sharingController = SharingController(text:sharedText);
        presentViewController(sharingController, animated:true, completion:nil)

        // GAIService.logEventWithCategory(GAICategories.uIUsage(), action: GAIActions.uIUsageShareTemplateSelected(), label: selectedTemplate!, value: 0)
    }

    private var cells: [(cell:UITableViewCell, row:Int)] {
        get {
            return (0 ... self.tableView.numberOfRowsInSection(0) - 1).map {
                row in
                return (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0))!, row)
            }
        }
    }

    private var anyoneJoiningMeCell: UITableViewCell {
        get {
            return cells[LikedPostings.AnyoneJoiningMe.rawValue].cell;
        }
    }

    private var iLikeRestaurantCell: UITableViewCell {
        get {
            return cells[LikedPostings.ILikeRestaurant.rawValue].cell;
        }
    }

    private var iLikeFoodHeroCell: UITableViewCell {
        get {
            return cells[LikedPostings.ILikeFoodHero.rawValue].cell;
        }
    }

    private var somethingElseCell: UITableViewCell {
        get {
            return cells[LikedPostings.SomethingElse.rawValue].cell;
        }
    }
}
