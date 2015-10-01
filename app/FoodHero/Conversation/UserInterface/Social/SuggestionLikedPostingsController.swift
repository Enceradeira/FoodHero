//
// Created by Jorg on 12/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class SuggestionLikedPostingsController: UITableViewController {
    private var restaurant: Restaurant!

    internal func setRestaurant(restaurant: Restaurant) {
        self.restaurant = restaurant

        iLikeRestaurantCell.textLabel!.text = "I like \(restaurant.name)"
    }

    private func logScreenViewed() {
        GAIService.logScreenViewed("ShareSuggestionLiked")
    }

    override func viewDidAppear(animated: Bool) {
        logScreenViewed()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var sharedText = ""
        var templateName = ""
        let selectedCell = cells.filter({ $0.row == indexPath.row }).first!
        switch (selectedCell.cell) {
        case anyoneJoiningMeCell:
            sharedText = SharingTextBuilder.anyoneJoiningMe(restaurant)
            templateName = "AnyoneJoiningMe"
        case iLikeRestaurantCell:
            sharedText = SharingTextBuilder.iLikeRestaurant(restaurant)
            templateName = "ILikeRestaurant"
        case iLikeFoodHeroCell:
            sharedText = SharingTextBuilder.foodHeroIsCool()
            templateName = "ILikeFoodHero"
        case somethingElseCell:
            sharedText = "\n\n" + SharingTextBuilder.downloadFoodHero()
            templateName = "SomethingElse"
        default:
            assert(false, "cell not found")

        }

        GAIService.logEventWithCategory(GAICategories.uIUsage(), action: GAIActions.uIUsageShareTemplateSelected(), label: templateName, value: 0)

        let sharingController = SharingController(text: sharedText) {
            self.logScreenViewed()
        }

        if sharingController.respondsToSelector("popoverPresentationController") && sharingController.popoverPresentationController != nil {
            sharingController.popoverPresentationController!.sourceView = view
        }

        presentViewController(sharingController, animated: true, completion: nil)

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
