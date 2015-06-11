//
// Created by Jorg on 23/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class HelpViewController: UIViewController {

    var _fhUtterance: String!
    var _expectedUserUtterances: ExpectedUserUtterances!
    var _delegate: IHelpViewControllerDelegate!

    override func viewDidAppear(animated: Bool) {
        GAIService.logScreenViewed("Help")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false;
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let controller = segue.destinationViewController as! UserUtterancesController
        controller.setExpectedUserUtterances(_expectedUserUtterances, delegate: _delegate!)
    }

    func setFhUtterance(
            fhUtterance: String,
            expectedUserUtterances: ExpectedUserUtterances,
            delegate: IHelpViewControllerDelegate) {
        _expectedUserUtterances = expectedUserUtterances
        _fhUtterance = fhUtterance
        _delegate = delegate;
    }
}
