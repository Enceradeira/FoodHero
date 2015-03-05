//
// Created by Jorg on 27/01/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ScriptResources: NSObject {
    var _parameters = [String: Array < String>]()
    let _randomizer: IRandomizer

    public init(randomizer: IRandomizer) {
        _randomizer = randomizer
    }

    public func add(#parameter: String, withValues values: [String]) -> ScriptResources {
        precondition(values.count > 0, "values must have at least one element")
        _parameters[parameter] = values
        return self
    }

    public func resolve(text: String) -> String {
        var result = text

        let regex = NSRegularExpression(pattern: "\\{(\\w+)\\}", options: .CaseInsensitive, error: nil)!
        let matches = regex.matchesInString(text, options: nil, range: NSMakeRange(0, countElements(text))) as [NSTextCheckingResult]

        for match in matches {
            let matchedString = (text as NSString).substringWithRange(NSMakeRange(match.range.location + 1, match.range.length - 2))
            let values = _parameters[matchedString]
            assert(values != nil, "ScriptResources don't contain values for parameter '\(matchedString)'")
            let resolvedString = _randomizer.chooseOne(from: values!, forTag: RandomizerConstants.textParameters()) as String
            let replaceRegex = NSRegularExpression(pattern: "\\{\(matchedString)\\}", options: .CaseInsensitive, error: nil)!
            result = replaceRegex.stringByReplacingMatchesInString(result, options: nil, range: NSMakeRange(0, countElements(result)), withTemplate: resolvedString)
        }
        return result
    }
}
