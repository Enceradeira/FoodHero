//
// Created by Jorg on 23/04/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class UserUtteranceTableViewCell: UITableViewCell {
    @IBOutlet private weak var utteranceLabel: UILabel!

    private var _delegate: IHelpViewControllerDelegate!
    private var _utterance = ""
    private var _gestureInitalized = false

    func setExpectedUserUtterance(
            utterance: String,
            delegate: IHelpViewControllerDelegate) {
        _utterance = utterance;
        _delegate = delegate;

        if !_gestureInitalized {
            let tapGesture = UITapGestureRecognizer(target: self, action: "userDidSelectUtterance")
            self.utteranceLabel.addGestureRecognizer(tapGesture)
            self.utteranceLabel.userInteractionEnabled = true

            _gestureInitalized = true
        }
        utteranceLabel.text = _utterance
    }

    func userDidSelectUtterance() {
        _delegate.userDidSelectUtterance(_utterance)
        GAIService.logEventWithCategory(GAICategories.uIUsage(), action: GAIActions.uIUsageHelpInput(), label: _utterance, value: 0)
    }
}
