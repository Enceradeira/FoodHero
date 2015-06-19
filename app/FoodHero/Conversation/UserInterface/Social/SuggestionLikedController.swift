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

    @IBAction func fbPostTouched(sender: AnyObject) {
        postTo(SLServiceTypeFacebook, serviceName: "Facebook", gaiAction: GAIActions.uIUsageShareFb()) {
            posting in
            posting.setInitialText(self.postingsController.postingTemplate)

            let url = NSURL(string: Constants.foodHeroProductUrl())
            posting.addURL(url)

        }
    }

    @IBAction func twitterPostTouched(sender: AnyObject) {
        postTo(SLServiceTypeTwitter, serviceName: "Twitter", gaiAction: GAIActions.uIUsageShareTwitter()) {
            posting in
            posting.setInitialText(self.postingsController.postingTemplate + "\n\n#FoodHero, \(Constants.foodHeroProductUrl())")
            // posting.addImage(UIImage(named: "AppIcon29x29"))

            // let url = NSURL(string: "www.jennius.co.uk")
            // posting.addURL(url)
        }
    }

    func postTo(serviceType: String, serviceName: String, gaiAction: String, initializer: (SLComposeViewController) -> ()) {
        if SLComposeViewController .isAvailableForServiceType(serviceType) {
            let posting = SLComposeViewController(forServiceType: serviceType)
            initializer(posting)
            posting.completionHandler = {
                (result: SLComposeViewControllerResult) in
                var desc = ""
                if result == .Done {
                    desc = "Done"
                } else {
                    desc = "Cancel"
                }
                GAIService.logEventWithCategory(GAICategories.uIUsage(), action: gaiAction, label: desc, value: 0)
            }
            presentViewController(posting, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Sharing Failed", message: "You can't post right now, make sure you have at least one \(serviceName) account setup at Settings > \(serviceName).", preferredStyle: UIAlertControllerStyle.Alert)
            if (environment.isVersionOrHigher(8, minor: 0)) {
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: {
                    action in
                    let url = NSURL(string: UIApplicationOpenSettingsURLString)!;
                    UIApplication.sharedApplication().openURL(url);
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))

            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
