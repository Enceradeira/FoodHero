//
// Created by Jorg on 19/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class SearchResultControlInput: NSObject, NSCoding {
    let result: RestaurantSearchResult

    public init(result: RestaurantSearchResult) {
        self.result = result
    }

    public required init?(coder: NSCoder) {
        result = coder.decodeObjectForKey("result") as! RestaurantSearchResult
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(result, forKey: "result");
    }

    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? SearchResultControlInput {
            if result != other.result {
                return false;
            }
            return true;
        }
        return false;
    }
}
