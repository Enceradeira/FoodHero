//
// Created by Jorg on 13/03/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class NetworkError: NSError {
    public  init() {
        super.init(domain: "uk.co.jennius", code: 0, userInfo: nil)
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
