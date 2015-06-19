//
// Created by Jorg on 12/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import Social

public class SuggestionLikedController: UIViewController, UITableViewDelegate {
    private var postingsController: SuggestionLikedPostingsController!
    private var environment: IEnvironment!
    private var restaurant: Restaurant!

    public func setEnvironment(env: IEnvironment) {
        environment = env
    }

    public func setRestaurant(restaurant: Restaurant) {
        self.restaurant = restaurant
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false;
    }

    public override func viewDidAppear(animated: Bool) {
        GAIService.logScreenViewed("Share")
    }

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        postingsController = segue.destinationViewController as! SuggestionLikedPostingsController
        postingsController.setRestaurant(restaurant)
    }
}
