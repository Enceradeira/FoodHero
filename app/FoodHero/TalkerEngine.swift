//
//  TalkerEngine.swift
//  FoodHero
//
//  Created by Jorg on 24/01/2015.
//  Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class TalkerEngine: NSObject{
    public override init(){}
    public func  Talk() -> Bool    {
        let signal = RACSignal.empty()
        return true
    }
}