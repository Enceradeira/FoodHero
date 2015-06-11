//
// Created by Jorg on 11/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class GAICategories: NSObject {
    /// How does WIT recognize
    public class func witRecognize() -> String {
        return "WitRecognize"
    }

    /// What UI Elements are used
    public class func uIUsage() -> String {
        return "UIUsage"
    }

    /// What do user search for
    public class func searchParams() -> String {
        return "SearchParams"
    }

    // Which occasions couldn't be guessed from cuisine
    public class func improvements() -> String {
        return "Improvments";
    }

}

public class GAIActions: NSObject {
    /// Wit detected an error
    public class func witUErrors() -> String {
        return "U:Errors"
    }

    /// User-Element for wit input used
    public class func uIUsageWitInput() -> String {
        return "WitInput"
    }

    /// User-Element for help used
    public class func uIUsageHelpInput() -> String {
        return "HelpInput"
    }

    /// User-Element for restaurant detail used
    public class func uIUsageRestaurantDetailInput() -> String {
        return "RestaurantDetailInput"
    }

    /// User-Element for restaurant detail used
    public class func uIUsageRestaurantMapInput() -> String {
        return "RestaurantMapInput"
    }

    /// Search Parameter Occasion
    public class func searchParamsOccasion() -> String {
        return "SearchOccasion"
    }

    /// Search Parameter Cuisien
    public class func searchParamsCusine() -> String {
        return "SearchCuisine"
    }

    public class func improvementNoOccasionGuessedForCuisine() -> String {
        return "NoOccassionGuessedForCuisine";
    }
}