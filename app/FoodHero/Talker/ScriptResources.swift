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

    public func add(parameter parameter: String, withValues values: [String]) -> ScriptResources {
        precondition(values.count > 0, "values must have at least one element")
        _parameters[parameter] = values
        return self
    }

    public func resolve(text: String) -> String {
        var result = text

        let regex = try! NSRegularExpression(pattern: "\\{(\\w+)\\}", options: .CaseInsensitive)
        let matches = regex.matchesInString(text, options: [], range: NSMakeRange(0, text.characters.count)) 

        for match in matches {
            let matchedString = (text as NSString).substringWithRange(NSMakeRange(match.range.location + 1, match.range.length - 2))
            let values = _parameters[matchedString]
            assert(values != nil, "ScriptResources don't contain values for parameter '\(matchedString)'")
            let resolvedString = _randomizer.chooseOne(from: values!, forTag: RandomizerConstants.textParameters()) as! String
            let replaceRegex = try! NSRegularExpression(pattern: "\\{\(matchedString)\\}", options: .CaseInsensitive)
            result = replaceRegex.stringByReplacingMatchesInString(result, options: [], range: NSMakeRange(0, result.characters.count), withTemplate: resolvedString)
        }
        return result
    }
}
