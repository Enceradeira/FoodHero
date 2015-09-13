//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class RestaurantReviewTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreObject() {
        let review = RestaurantReviewBuilder().build()

        let decodedReview = CodingHelper.encodeAndDecode(review)
        XCTAssertEqual(decodedReview, review)
    }
}
