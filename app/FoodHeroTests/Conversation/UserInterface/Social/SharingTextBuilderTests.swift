//
// Created by Jorg on 19/06/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class SharingTextBuilderTests: XCTestCase {
    let _restaurant = RestaurantBuilder().build()
    let _restaurantWithoutUrl = RestaurantBuilder().withUrl("").withUrlForDisplaying("").build()

    func test_foodHeroIsCool_ShouldReturnFormattedText() {
        let text = SharingTextBuilder.foodHeroIsCool()
        
        XCTAssertEqual(text, "Food Hero is cool!\n\nDownload it for free from www.jennius.co.uk")
    }

    func test_foodHeroSuggested_ShouldReturnFormattedText_WhenUrlPresent() {
        let text = SharingTextBuilder.foodHeroSuggested("Go to King's Head", restaurant: _restaurant)
        XCTAssertEqual(text, "Food Hero said:\n\nGo to King's Head\nnamaste.co.uk\n\nDownload Food Hero from www.jennius.co.uk")
    }

    func test_foodHeroSuggested_ShouldReturnFormattedText_WhenNoUrlPresent() {
        let text = SharingTextBuilder.foodHeroSuggested("Go to King's Head", restaurant: _restaurantWithoutUrl)
        XCTAssertEqual(text, "Food Hero said:\n\nGo to King's Head\n\nDownload Food Hero from www.jennius.co.uk")
    }

    func test_anyoneJoingingMe_ShouldReturnFormattedText_WhenUrlPresent() {
        let text = SharingTextBuilder.anyoneJoiningMe(_restaurant)
        XCTAssertEqual(text, "I'm going to Raj Palace (namaste.co.uk).\n\nAnyone joining me?\n\nDownload Food Hero from www.jennius.co.uk")
    }

    func test_anyoneJoingingMe_ShouldReturnFormattedText_WhenNOUrlPresent() {
        let text = SharingTextBuilder.anyoneJoiningMe(_restaurantWithoutUrl)
        XCTAssertEqual(text, "I'm going to Raj Palace.\n\nAnyone joining me?\n\nDownload Food Hero from www.jennius.co.uk")
    }
    
    func test_iLikeRestaurant_ShouldReturnFormattedText_WhenUrlPresent() {
        let text = SharingTextBuilder.iLikeRestaurant(_restaurant)
        XCTAssertEqual(text, "I like Raj Palace (namaste.co.uk).\n\nDownload Food Hero from www.jennius.co.uk")
    }
    
    func test_iLikeRestaurant_ShouldReturnFormattedText_WhenNoUrlPresent() {
        let text = SharingTextBuilder.iLikeRestaurant(_restaurantWithoutUrl)
        XCTAssertEqual(text, "I like Raj Palace.\n\nDownload Food Hero from www.jennius.co.uk")
    }

    func test_downloadFoodHero_SholdReturnFormattedText() {
        let text = SharingTextBuilder.downloadFoodHero()
        XCTAssertEqual(text, "Download Food Hero from www.jennius.co.uk")
    }

}
