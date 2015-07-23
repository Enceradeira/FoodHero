//
// Created by Jorg on 23/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class PlacesAPIStub: NSObject, IPlacesAPI {

    private let _ownSearchResult = [
            RestaurantBuilder().withName("King's Head").withVicinity("Norwich").build(),
            RestaurantBuilder().withName("Raj Palace").withVicinity("Norwich").build(),
            RestaurantBuilder().withName("Thai Inn").withVicinity("Norwich").build(),
            RestaurantBuilder().withName("Drunken Monk").withVicinity("Norwich").build(),
            RestaurantBuilder().withName("Vegi Castle").withVicinity("Norwich").build(),
            RestaurantBuilder().withName("Sausages & Cows").withVicinity("Norwich").build(),
            RestaurantBuilder().withName("Walumpo").withVicinity("Norwich").build(),
            RestaurantBuilder().withName("Chinese Take Away").withVicinity("Norwich").build(),
            RestaurantBuilder().withName("Posh Food").withVicinity("Norwich").build(),
            RestaurantBuilder().withName("Dal Fury").withVicinity("Norwich").build(),
    ]

    public func findPlaces(cuisine: String, occasion: String, location: CLLocation) -> AnyObject {
        return _ownSearchResult
    }
}
