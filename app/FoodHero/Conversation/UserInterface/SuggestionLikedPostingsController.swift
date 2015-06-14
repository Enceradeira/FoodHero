//
// Created by Jorg on 12/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class SuggestionLikedPostingsController: UITableViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        // make checkmarks red
        tableView.tintColor = FoodHeroColors.actionColor()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        for cell in cells {
            cell.cell.accessoryType = cell.row == indexPath.row ? .Checkmark : .None
        }
    }

    override func viewDidAppear(animated: Bool)
    {
        let cellDesc = cells[LikedPostings.ILikeFoodHero.rawValue]
        cellDesc.cell.accessoryType = .Checkmark
        let indexPath = NSIndexPath(forRow: cellDesc.row, inSection: 0)
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
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

    internal var postingTemplate: String {
        get {
            if anyoneJoiningMeCell.accessoryType == .Checkmark {
                return "Anyone joining me?"
            } else if iLikeRestaurantCell.accessoryType == .Checkmark {
                return "I like RESTARUANT"
            } else if iLikeFoodHeroCell.accessoryType == .Checkmark {
                return "Food Hero is cool"
            }
            return "";
        }
    }

}
