//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import MessageUI

class FeedbackController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    private var _mailController: MFMailComposeViewController!


    override func viewDidLoad() {
        super.viewDidLoad()

        _mailController = MFMailComposeViewController()
        _mailController.navigationBar.tintColor = FoodHeroColors.actionColor()
        _mailController.mailComposeDelegate = self

        let mailView = _mailController.view
        // controllerView which becomes the container content, should not resize because we control resizing with constraints
        mailView.setTranslatesAutoresizingMaskIntoConstraints(false)

        addChildViewController(_mailController)
        containerView.addSubview(mailView)
        containerView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .Top, relatedBy: .Equal, toItem: mailView, attribute: .Top, multiplier: 1, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: mailView, attribute: .Bottom, multiplier: 1, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .Left, relatedBy: .Equal, toItem: mailView, attribute: .Left, multiplier: 1, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: containerView, attribute: .Right, relatedBy: .Equal, toItem: mailView, attribute: .Right, multiplier: 1, constant: 0))
        _mailController.didMoveToParentViewController(self)

        initEMail()
    }

    private func initEMail() {
        _mailController.setSubject("My opinion about FoodHero")
        _mailController.setToRecipients(["foodhero@jennius.co.uk"])
        _mailController.setMessageBody("", isHTML: false)
    }


    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.navigationController!.popViewControllerAnimated(true)
    }

}
