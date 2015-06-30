//
// Created by Jorg on 29/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

@objc
public protocol IGeocoderService {
    func geocodeAddressString(address: String) -> RACSignal;
}
