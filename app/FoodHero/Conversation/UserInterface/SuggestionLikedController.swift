//
// Created by Jorg on 12/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class SuggestionLikedController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var postsTableView: UITableView!

    override func viewDidLoad() {

        super.viewDidLoad()
        postsTableView.delegate = self
    }

}
