//
// Created by Jorg on 24/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerStreams: NSObject {
    private let _rawOutput: RACSignal
    private let _naturalOutput: RACSignal
    public init(rawOutput: RACSignal, naturalOutput: RACSignal) {
        _rawOutput = rawOutput;
        _naturalOutput = naturalOutput;
    }
    public var rawOutput: RACSignal {
        get {
            return _rawOutput;
        }
    }
    public var naturalOutput: RACSignal {
        get {
            return _naturalOutput;
        }
    }
}

