//
// Created by Jorg on 12/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import Social

public class SuggestionLikedController: UIViewController, UITableViewDelegate {
    private var postingsController: SuggestionLikedPostingsController!
    private var environment: IEnvironment!

    public func setEnvironment(env: IEnvironment) {
        environment = env
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        postingsController = segue.destinationViewController as! SuggestionLikedPostingsController
    }

    @IBAction func fbPostTouched(sender: AnyObject) {
        postTo(SLServiceTypeFacebook, serviceName: "Facebook")
    }

    @IBAction func twitterPostTouched(sender: AnyObject) {
        postTo(SLServiceTypeTwitter, serviceName: "Twitter")
    }

    func postTo(serviceType: String, serviceName: String) {
        if SLComposeViewController .isAvailableForServiceType(serviceType) {
            let posting = SLComposeViewController(forServiceType: serviceType)
            posting.setInitialText(postingsController.postingTemplate)
            let url = NSURL(string: "www.jennius.co.uk")
            let image = UIImage(named: "AppIcon40x40")
            posting.addImage(image)
            posting.addURL(url)

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
