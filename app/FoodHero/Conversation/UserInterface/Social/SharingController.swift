//
// Created by Jorg on 19/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class SharingController: UIActivityViewController {
    public init(text: String, completion:()->()) {

        super.init(activityItems: [text], applicationActivities: nil)

        excludedActivityTypes = [
                UIActivityTypePrint,
                UIActivityTypeAssignToContact,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypeAddToReadingList,
                UIActivityTypeAirDrop
        ]

        completionWithItemsHandler = {
            activity, success, items, error in
            if success {
                GAIService.logEventWithCategory(GAICategories.uIUsage(), action: GAIActions.uIUsageShare(), label: activity, value: 0)
            } else {
                GAIService.logEventWithCategory(GAICategories.uIUsage(), action: GAIActions.uIUsageShare(), label: "Cancel", value: 0)
            }
            completion()
        }
    }

    public override func viewDidAppear(animated: Bool) {
        GAIService.logScreenViewed("Share")
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
