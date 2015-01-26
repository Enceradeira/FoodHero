//
// Created by Jorg on 26/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class GenericWrapper<T> {
    public let element : T
    public init(_ element : T) {
        self.element = element
    }
}