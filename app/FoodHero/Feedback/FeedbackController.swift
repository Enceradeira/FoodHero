//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class FeedbackController: UIViewController {
    @IBAction func didClickSubmit(sender: UIButton) {
        navigationController!.popViewControllerAnimated(true)
    }
}
