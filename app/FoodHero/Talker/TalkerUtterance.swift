//
// Created by Jorg on 09/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerUtterance: NSObject {
    public let utterance: String;
    public let customData: [AnyObject]

    public convenience override init() {
        self.init(utterance: "", customData: nil)
    }

    public convenience init(utterance: String, customData: AnyObject? = nil) {
        let customDataArray = customData != nil ? [customData!] : []
        self.init(utterance: utterance, customData: customDataArray)
    }

    private init(utterance: String, customData: [AnyObject]) {
        self.utterance = utterance;
        self.customData = customData
    }

    public func concat(other: TalkerUtterance) -> TalkerUtterance {
        var utteranceArray: [String] = []
        if count(utterance) > 0 {
            utteranceArray.append(utterance)
        }
        if count(other.utterance) > 0 {
            utteranceArray.append(other.utterance)
        }

        let utterances = "\n\n".join(utteranceArray)
        let customData = self.customData + other.customData
        return TalkerUtterance(utterance: utterances, customData: customData)
    }
}
