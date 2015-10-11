//
// Created by Jorg on 19/07/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public extension String {
    public func stringByRemovingCharacterAtTheEnd(character: Character) -> String {
        let len = self.characters.count
        if len < 1 {
            return self
        }

        let idx = self.endIndex.advancedBy(-1)
        if self[idx] == character {
            return self.substringToIndex(idx)
        } else {
            return self
        }
    }
}
