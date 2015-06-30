//
// Created by Jorg on 11/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class GAICategories: NSObject {
    /// How does WIT recognize
    /*
    public class func witRecognize() -> String {
        return "WitRecognize"
    } */

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

    // How enganged are users
    public class func engagement() -> String {
        return "Engagement"
    }

    public class func negativeExperience() -> String {
        return "NegativeExperience"
    }

    public class func externalCallTimings() -> String {
        return "ExternalCallTimings"
    }
}

public class GAITimingNames: NSObject {
    public class func wit() -> String {
        return "Wit"
    }

    public class func restaurantRepository() -> String {
        return "RestaurantRepository"
    }

    public class func geocoderService() -> String {
        return "geocoderService"
    }
}

public class GAIActions: NSObject {
    /// User-Element for wit input used
    public class func uIUsageWitInput() -> String {
        return "WitInput"
    }

    /// User-Element for help used
    public class func uIUsageHelpInput() -> String {
        return "HelpInput"
    }

    /// User-Element for when share is sent or canceled
    public class func uIUsageShare() -> String {
        return "ShareSend"
    }

    /// User-Element for share-template used
    public class func uIUsageShareTemplateSelected() -> String {
        return "ShareTemplateSelected"
    }

    /// User-Element for share-template used
    public class func uIUsageAllowDataCollection() -> String {
        return "AllowDataCollection"
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

    /// Event when no occasion could be guessed from cuisine
    public class func improvementNoOccasionGuessedForCuisine() -> String {
        return "NoOccassionGuessedForCuisine";
    }

    /// Event when a certain progress in the conversation was reached
    public class func engagementConversation() -> String {
        return "ConversationProgress"
    }

    public class func negativeExperienceError() -> String {
        return "NegativeExperienceError"
    }
}