//
// Created by Jorg on 19/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class SharingController: UIActivityViewController {
    public init(text: String) {

        super.init(activityItems: [text], applicationActivities: nil)

        excludedActivityTypes = [
                UIActivityTypePrint,
                UIActivityTypeAssignToContact,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypeAddToReadingList,
                UIActivityTypeAirDrop
        ]
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }

}
