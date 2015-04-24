//
// Created by Jorg on 23/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class UserUtterancesController: UITableViewController {
    var _expectedUserUtterances = ExpectedUserUtterances()
    var _delegate: IHelpViewControllerDelegate!

    func setExpectedUserUtterances(
            expectedUserUtterances: ExpectedUserUtterances,
            delegate: IHelpViewControllerDelegate) {
        _expectedUserUtterances = expectedUserUtterances;
        _delegate = delegate;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _expectedUserUtterances.utterances.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("utterance", forIndexPath: indexPath) as! UserUtteranceTableViewCell

        let row = indexPath.row
        cell.setExpectedUserUtterance(_expectedUserUtterances.utterances[row], delegate: _delegate)

        return cell
    }
}
