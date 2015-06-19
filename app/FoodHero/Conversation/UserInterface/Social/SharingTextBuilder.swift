//
// Created by Jorg on 19/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class SharingTextBuilder: NSObject {

    private static let productUrl = "www.jennius.co.uk"

    private class func getRestaurantUrlOrEmpty(restaurant: Restaurant) -> String {
        if let urlForDisplaying = restaurant.urlForDisplaying {
            if count(urlForDisplaying) > 0 {
                return urlForDisplaying
            }
        }
        return "";
    }

    public class func foodHeroIsCool() -> String {
        return "Food Hero is cool!\n\nDownload it for free from \(productUrl)"
    }

    public class func foodHeroSuggested(utterance: String, restaurant: Restaurant) -> String {
        var url = getRestaurantUrlOrEmpty(restaurant)
        if !url.isEmpty{
            url = "\n\(url)"
        }

        return "Food Hero said:\n\n\(utterance)\(url)\n\n\(downloadFoodHero())"
    }

    public class func anyoneJoiningMe(restaurant: Restaurant) -> String {
        var url = getRestaurantUrlOrEmpty(restaurant)
        if !url.isEmpty{
            url = " (\(url))"
        }
        return "I'm going to \(restaurant.name)\(url).\n\nAnyone joining me?\n\n\(downloadFoodHero())"
    }

    public class func iLikeRestaurant(restaurant: Restaurant) -> String {
        var url = getRestaurantUrlOrEmpty(restaurant)
        if !url.isEmpty{
            url = " (\(url))"
        }
        return "I like \(restaurant.name)\(url).\n\n\(downloadFoodHero())"
    }

    public class func downloadFoodHero() -> String {
        return "Download Food Hero from \(productUrl)"
    }

}
