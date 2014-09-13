//
// Created by Jorg on 13/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TextRepository.h"


@implementation TextRepository {

    id <Randomizer> _randomizer;
}

- (instancetype)initWithRandomizer:(id <Randomizer>)randomizer {
    self = [super init];
    if (self != nil) {
        _randomizer = randomizer;
    }
    return self;
}

- (NSString *)getFemaleCelebrity {
    return [_randomizer chooseOneTextFor:@"FemaleCelebrity" texts:@[
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
    return [_randomizer chooseOneTextFor:@"MaleCelebrity" texts:@[
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

    return [_randomizer chooseOneTextFor:@"Greeting" texts:@[
            @"Hi there.",
            @"Hello beautiful.",
            @"Have you put on your lipstick today?",
            @"‘Sup man?",
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
    NSString *placeName = [_randomizer chooseOneTextFor:@"Place" texts:@[
            @"Machu Picchu",
            @"the toilet",
            @"Llanfairpwllgwyngyll",
            @"Mars",
            @"Abu Dhabi"
    ]];
    return placeName;
}

- (NSString *)getSuggestion {
    return [_randomizer chooseOneTextFor:@"Suggestion" texts:@[
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
    return [_randomizer chooseOneTextFor:@"Celebrity" texts:@[[self getFemaleCelebrity], [self getMaleCelebrity]]];
}
@end