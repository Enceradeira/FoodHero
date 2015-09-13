//
// Created by Jorg on 09/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerUtterance: NSObject, NSCoding {
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

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(utterance, forKey: "utterance");
        aCoder.encodeObject(customData, forKey: "customData");
    }

    public required init(coder aDecoder: NSCoder) {
        utterance = aDecoder.decodeObjectForKey("utterance") as! String
        customData = aDecoder.decodeObjectForKey("customData") as! [AnyObject]
    }

    public override func isEqual(other: AnyObject?) -> Bool {
        if let other = other as? TalkerUtterance {
            if utterance != other.utterance {
                return false;
            }
            if !(customData as NSArray).isEqualToArray(other.customData) {
                return false;
            }
            return true;
        }
        return false;
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
