// Created by Jorg on 15/07/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "FHGreeting.h"
#import "TyphoonComponents.h"
#import "DefaultRandomizer.h"


@implementation FHGreeting {

}
+ (FHGreeting *)create {
    id <Randomizer> randomizer = [(id <ApplicationAssembly>) [TyphoonComponents factory] randomizer];
    NSString *femaleCelebrity = [randomizer chooseOneTextFrom:@[
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

    NSString *maleCelebrity = [randomizer chooseOneTextFrom:@[
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

    NSString *placeName = [randomizer chooseOneTextFrom:@[
            @"Machu Picchu",
            @"the toilet",
            @"Llanfairpwllgwyngyll",
            @"Mars",
            @"Abu Dhabi"
    ]];

    NSString *text = [randomizer chooseOneTextFrom:@[
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
    return [[FHGreeting alloc] initWithSemanticId:@"FH:Greeting" text:text];
}
@end
