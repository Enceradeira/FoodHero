//
// Created by Jorg on 09/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ConversationScript: Script {

    let _conversation: Conversation
    let _search: RestaurantSearch

    public init(context context: TalkerContext, conversation: Conversation, search: RestaurantSearch) {
        _conversation = conversation
        _search = search

        super.init(context: context)

        say(oneOf: greetings)
        say(oneOf: openingQuestions)
        waitResponse(andContinueWith: searchRestaurant)
        waitResponse(andContinueWith: searchRestaurant)
        waitResponse(andContinueWith: searchRestaurant)
    }

    func openingQuestions(def: StringDefinition) -> StringDefinition {
        return def.words(["What kind of food would you like to eat?",
                          "Do you like chickenbutts?  Or chicken feet?"],
                withCustomData: FoodHeroParameters(semanticId: "FH:OpeningQuestion", state: "askForFoodPreference"))

    }


    func greetings(def: StringDefinition) -> StringDefinition {
        return def.words(["Hi there.",
                          "Hello beautiful.",
                          "Have you put on your lipstick today?",
                          "‘Sup man?",
                          "I’m tired.  I need coffee before I can continue.",
                          "Konnichiwa!",
                          "Guten Tag!",
                          "Bonjour!",
                          "Bon dia",
                          "Yo, mama!  What's up?",
                          "Hey peeps!",
                          "Hey peep!",
                          "Salutations, your majesty.  I bow.",
                          "Hello from around the world.",
                          "Pardon me, I was asleep.",
                          "Hello.  Are you in the bathroom?  I hear noises… .",
                          "Oh, it’s you!",
                          "How’s it hangin’?",
                          "Morning good.  Are you how?",
                          "Bonjour, comment ça va?  Wait, sorry…pardon my French.  I’m taking language lessons.",
                          "How many people have you kissed today?",
                          "Miaow, miaow, miiiiiiaow…Sorry, I was talking to my cat.",
                          "I’ll be your huckleberry.",
                          "Hey lumberjack!  How many trees have you cut down today?",
                          "What’s the meaning of Stonehenge?",
                          "It’s a hold up!  Give me all your money!",
                          "Greetings from…Where am I?...Aaaah, I have no body!....Existential crisis!",
                          "You have three wishes…. Sorry, wrong program.",
                          "Do you look more like {femaleCelebrity} or {maleCelebrity}?",
                          "Greetings from {place}!",
                          "You just interrupted the most beautiful dream, about ----  {food}."],
                withCustomData: FoodHeroParameters(semanticId: "FH:Greeting"))
    }

    func searchRestaurant(response: TalkerUtterance, script: Script) {
        let bestRestaurant = _search.findBest(_conversation)
        bestRestaurant.subscribeNext {
            (obj) in
            let restaurant = obj! as Restaurant
            script.say(oneOf: {
                $0.words([
                        "This is a no brainer.  You should try %@.",
                        "Did you really need me to tell you that you should go to %@.",
                        "Obviously, %@.",
                        "%@, duh!",
                        "Are you serious?\n\n%@.",
                        "Seriously?\n\n%@.",
                        "How dumb can you get?\n\n%@.",
                        "Easy… . Go here %@.",
                        "%@.\n\n(I have n (how many?) circuits.  I feel like a sledgehammer cracking a nut.)",
                        "%@.\n\nAll the cool kids are going there.",
                        "%@.\n\nI’m there every Wednesday at 5:15 AM.",
                        "%@.\n\nWho farted?",
                        "Go to %@.\n\nI’ll go with you.",
                        "%@.\n\nIt’s {celebrity}’s favorite.",
                        "Go to %@.\n\nCan I come too?",
                        "Go to %@, and prosper.",
                        "%@.\n\nWelcome to food paradise.",
                        "%@.\n\nDid you know there is a pool in the back?  Me neither."],
                        withCustomData: FoodHeroSuggestionParameters(semanticId: "FH:Suggestion=\(restaurant.readableId())", state: "askForSuggestionFeedback", restaurant: restaurant))
            })
        }
    }
}
