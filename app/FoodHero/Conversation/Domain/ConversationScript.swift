//
// Created by Jorg on 09/02/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ConversationScript: Script {

    public override init(context context: TalkerContext) {
        super.init(context: context)

        say(oneOf: ["Hi there.",
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
                    "Do you look more like {felmaleCelebrity} or {maleCelebrity}?",
                    "Greetings from {place}!",
                    "You just interrupted the most beautiful dream, about ----  {food}."],
                withCustomData: "FH:Greeting")

        say(oneOf: ["What kind of food would you like to eat?",
                    "Do you like chickenbutts?  Or chicken feet?"],
                withCustomData: "FH:OpeningQuestion")

        waitResponse(byInvoking: {
            "TODO"
            return
        })

    }
}
