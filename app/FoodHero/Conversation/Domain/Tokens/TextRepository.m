//
// Created by Jorg on 13/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TextRepository.h"

@implementation TextRepository {

    id <Randomizer> _randomizer;
}

const NSString *ContextFemaleCelebrity = @"FemaleCelebrity";
const NSString *ContextCommentChoice = @"CommentChoice";
const NSString *ContextWhatToDoNextComment = @"WhatToDoNextComment";
const NSString *ContextGoodByeAfterSuccess = @"GoodByeAfterSuccess";
const NSString *ContextMaleCelebrity = @"MaleCelebrity";
const NSString *ContextGreeting = @"Greeting";
const NSString *ContextPlace = @"Place";
const NSString *ContextSuggestion = @"Suggestion";
const NSString *ContextOpeningQuestion = @"OpeningQuestion";
const NSString *ContextCelebrity = @"Celebrity";
const NSString *ContextSuggestionWithConfirmationIfInNewPreferredRangeCheaper = @"SuggestionWithConfirmationIfInNewPreferredRangeCheaper";

- (instancetype)initWithRandomizer:(id <Randomizer>)randomizer {
    self = [super init];
    if (self != nil) {
        _randomizer = randomizer;
    }
    return self;
}

- (NSString *)getFemaleCelebrity {
    return [_randomizer chooseOneTextFor:ContextFemaleCelebrity texts:@[
            @"Taylor Swift",
            @"Zoe Saldana",
            @"Ariana Grande",
            @"Hilary Duff",
            @"Britney Spears",
            @"Lea Michele",
            @"Jennifer Lawrence",
            @"Michelle Keegan",
            @"Rihanna",
            @"Emily Ratajkowski",
            @"Kaley Cuoco",
            @"Mila Kunis",
            @"Beyonce",
            @"Lucy Mecklenburgh",
            @"Nicole Scherzinger",
            @"Scarlett Johansson",
            @"Cate Blanchett",
            @"Lupita Nyong'o",
            @"Emma Stone",
            @"Keira Knightley",
            @"Jessica Ennis-Hill",
            @"Kate Winslet",
            @"Angelina Jolie",
            @"Nigella Lawson",
            @"Amy Willerton",
            @"Kelly Brook",
            @"Mel Clarke",
            @"Georgia Salpa",
            @"Margot Robbie",
            @"Jorgie Porter",
            @"Megan Fox",
            @"Susanna Reid",
            @"Kendall Jenner",
            @"Jenna-Louise Coleman",
            @"Amy Adams",
            @"Zooey Deschanel",
            @"Rita Ora",
            @"Jennifer Aniston",
            @"Holly Willoughby",
            @"Kim Kardashian",
            @"Alison Brie",
            @"Kate Moss",
            @"Meagan Good",
            @"Amanda Seyfried",
            @"Kate Middleton",
            @"Pippa Middleton",
            @"Carmen Electra",
            @"Emily Blunt",
            @"Lois Griffin from Family Guy",
            @"Sandra Bullock"
    ]];
}

- (NSString *)getMaleCelebrity {
    return [_randomizer chooseOneTextFor:ContextMaleCelebrity texts:@[
            @"Kanye West",
            @"Jay-Z",
            @"Henry Cavill",
            @"Robert Pattinson",
            @"Liam Hemsworth",
            @"Tom Hiddleston",
            @"Benedict Cumberbatch",
            @"Harry Styles",
            @"Chris Hemsworth",
            @"Idris Elba",
            @"Jamie Campbell Bower",
            @"Justin Bieber",
            @"Charlie Hunnam",
            @"Ian Somerhalder",
            @"Matt Bomer",
            @"Johnny Depp",
            @"Olly Murs",
            @"Michael Fassbender",
            @"Channing Tatum",
            @"Rafa Nadal",
            @"Matt Smith",
            @"Robert Downey Jnr",
            @"David Beckham",
            @"Hugh Jackman",
            @"Orlando Bloom",
            @"Josh Hutcherson",
            @"Paul Wesley",
            @"Zayn Malik",
            @"Pharrell Williams",
            @"Zac Efron",
            @"Ryan Gosling",
            @"Taylor Lautner",
            @"James Franco",
            @"Liam Payne",
            @"Tinie Tempah",
            @"Kit Harington",
            @"Alex Turner",
            @"Tom Hardy",
            @"Tom Daley",
            @"Nathan Sykes",
            @"Justin Timberlake",
            @"Daniel Craig",
            @"Andy Murray",
            @"Brad Pitt",
            @"Ashton Kutcher",
            @"George Clooney"
    ]];
}

- (NSString *)getGreeting {
    NSString *femaleCelebrity = [self getFemaleCelebrity];
    NSString *maleCelebrity = [self getMaleCelebrity];
    NSString *placeName = [self getPlace];

    return [_randomizer chooseOneTextFor:ContextGreeting texts:@[
            @"Hi there.",
            @"Hello beautiful.",
            @"Have you put on your lipstick today?",
            @"‘Sup man?",
            @"I’m tired.  I need coffee before I can continue.",
            @"Konnichiwa!",
            @"Guten Tag!",
            @"Bonjour!",
            @"Bon dia",
            @"Yo, mama!  What's up?",
            @"Hey peeps!",
            @"Hey peep!",
            @"Salutations, your majesty.  I bow.",
            @"Hello from around the world.",
            @"Pardon me, I was asleep.",
            @"Hello.  Are you in the bathroom?  I hear noises… .",
            @"Oh, it’s you!",
            @"How’s it hangin’?",
            @"Morning good.  Are you how?",
            @"Bonjour, comment ça va?  Wait, sorry…pardon my French.  I’m taking language lessons.",
            @"How many people have you kissed today?",
            @"Miaow, miaow, miiiiiiaow…Sorry, I was talking to my cat.",
            @"I’ll be your huckleberry.",
            @"Hey lumberjack!  How many trees have you cut down today?",
            @"What’s the meaning of Stonehenge?",
            @"It’s a hold up!  Give me all your money!",
            @"Greetings from…Where am I?...Aaaah, I have no body!....Existential crisis!",
            @"You have three wishes…. Sorry, wrong program.",
            [NSString stringWithFormat:@"Do you look more like %@ or %@?", femaleCelebrity, maleCelebrity],
            [NSString stringWithFormat:@"Greetings from %@!", placeName],
    ]];
}

- (NSString *)getPlace {
    NSString *placeName = [_randomizer chooseOneTextFor:ContextPlace texts:@[
            @"Machu Picchu",
            @"the toilet",
            @"Llanfairpwllgwyngyll",
            @"Mars",
            @"Abu Dhabi"
    ]];
    return placeName;
}

- (NSString *)getSuggestion {
    return [_randomizer chooseOneTextFor:ContextSuggestion texts:@[
            //@"Maybe you like %@?",
            //@"Would you fancy %@?",
            //@"What about %@?",
            @"This is a no brainer.  You should try %@.",
            @"Did you really need me to tell you that you should go to %@.",
            @"Obviously, %@.",
            @"%@, duh!",
            @"Are you serious?\n\n%@.",
            @"Seriously?\n\n%@.",
            @"How dumb can you get?\n\n%@.",
            @"Easy… . Go here %@.",
            @"%@.\n\n(I have n (how many?) circuits.  I feel like a sledgehammer cracking a nut.)",
            @"%@.\n\nAll the cool kids are going there.",
            @"%@.\n\nI’m there every Wednesday at 5:15 AM.",
            @"%@.\n\nWho farted?",
            @"Go to %@.\n\nI’ll go with you.",
            [NSString stringWithFormat:@"%@.\n\nIt’s %@’s favorite.", @"%@", [self getCelebrity]],
            @"Go to %@.\n\nCan I come too?",
            @"Go to %@, and prosper.",
            @"%@.\n\nWelcome to food paradise.",
            @"%@.\n\nDid you know there is a pool in the back?  Me neither."
    ]];
}

- (NSString *)getCelebrity {
    return [_randomizer chooseOneTextFor:ContextCelebrity texts:@[[self getFemaleCelebrity], [self getMaleCelebrity]]];
}

- (NSString *)getSuggestionWithConfirmationIfInNewPreferredRangeCheaper {
    return [_randomizer chooseOneTextFor:ContextSuggestionWithConfirmationIfInNewPreferredRangeCheaper texts:@[
            @"If you like it cheaper, the %@ could be your choice",
            @"If you want to go to a really good restaurant without paying too much…get famous!\n\nOtherwise try %@."
    ]];
}

- (NSString *)getGoodByeAfterSuccess {
    return [_randomizer chooseOneTextFor:ContextGoodByeAfterSuccess texts:@[
            @"See you!",
            @"God bless you.",
            @"Behave yourself, now.",
            @"Don’t get a girl in trouble.",
    ]];
}

- (NSString *)getCommentChoice {
    return [_randomizer chooseOneTextFor:ContextCommentChoice texts:@[
            @"Love this place. See you there.",
            @"Yes!  I got you to do it!",
            @"Bring me your leftovers.",
            @"Yes!  You’ll be their third customer.",
            @"Yes!  You can write the eulogy for their previous customer.",
            @"Bring me a sandwich back and I’ll start building a vacation home.",
            @"Ask for Ben, he’s my cousin.",
            @"Yippideedee bananadorama bananadorama!",
            @"Yay!  I’ll do my happy dance.  Please give me some privacy [doing happy dance].",
            @"Fingers crossed—I hope you like it.",
            @"It sounds corny, but I really do like helping people.",
            @"Or you could just order a pizza and be done with it.",
            @"I hope it is worthy of you.",
            [NSString stringWithFormat:@"I’ll tell you what to order—some eggs and bacon with mayonnaise. That’s %@’s favorite.", [self getCelebrity]],
            @"I want sprinkles!",
            @"Bring your sweater.  Sometimes it can be chilly."
    ]];
}

- (NSString *)getWhatToDoNextComment {
    return [_randomizer chooseOneTextFor:ContextWhatToDoNextComment texts:@[
            @"Anything else?",
            @"I’m bored! Anything else?"
    ]];
}

- (NSString *)getOpeningQuestion {
    return [_randomizer chooseOneTextFor:ContextWhatToDoNextComment texts:@[
            @"What kind of food would you like to eat?",
            @"Do you like chickenbutts?  Or chicken feet?\n\nOr which food then?"
    ]];
}

@end