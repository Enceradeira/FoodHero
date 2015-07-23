//
// Created by Jorg on 19/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class FHPlacesUrlBuilder {
    private let _baseUrl: String

    public init(baseUrl: String) {
        assert(!baseUrl.isEmpty, "baseUrl can't be empty")
        _baseUrl = baseUrl.stringByRemovingCharacterAtTheEnd("/")
    }

    public func buildUrlWithCuisine(cuisine: String, occasion: String, location: CLLocation) -> String {
        let cuisineEncoded = KeywordEncoder.encodeString(cuisine)
        let occasionEncoded = KeywordEncoder.encodeString(occasion)
        let coordinate = location.coordinate
        return "\(_baseUrl)/api/v1/places?cuisine=\(cuisineEncoded)&occasion=\(occasionEncoded)&location=\(coordinate.latitude),\(coordinate.longitude)"
    }
}
