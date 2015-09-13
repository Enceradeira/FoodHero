//
// Created by Jorg on 12/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

class GooglePhotoTests: XCTestCase {
    func test_encodeDecode_ShouldRestoreObject() {
        let photo = GooglePhoto(reference: "A-B", height: 45, width: 123, loadEagerly: true)

        let decodedPhoto = CodingHelper.encodeAndDecode(photo)
        XCTAssertEqual(decodedPhoto, photo)
    }
}
