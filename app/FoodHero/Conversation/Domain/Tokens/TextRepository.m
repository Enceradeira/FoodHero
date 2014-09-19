//
// Created by Jorg on 13/09/2014.
// Copyright (c) 2014 JENNIUS LTD. All rights reserved.
//

#import "TextRepository.h"


TextAndSound *t(NSString *text) {
    return [TextAndSound create:text];
}

TextAndSound *ts(NSString *text, Sound *sound) {
    return [TextAndSound create:text sound:sound];
}

@implementation TextRepository {

    id <Randomizer> _randomizer;
}

NSString *const ContextFemaleCelebrity = @"FemaleCelebrity";
NSString *const ContextCommentChoice = @"CommentChoice";
NSString *const ContextWhatToDoNextComment = @"WhatToDoNextComment";
NSString *const ContextGoodByeAfterSuccess = @"GoodByeAfterSuccess";
NSString *const ContextMaleCelebrity = @"MaleCelebrity";
NSString *const ContextGreeting = @"Greeting";
NSString *const ContextPlace = @"Place";
NSString *const ContextSuggestion = @"Suggestion";
NSString *const ContextOpeningQuestion = @"OpeningQuestion";
NSString *const ContextCelebrity = @"Celebrity";
NSString *const ContextFood = @"Food";
NSString *const ContextSuggestionWithConfirmationIfInNewPreferredRangeCheaper = @"SuggestionWithConfirmationIfInNewPreferredRangeCheaper";

- (instancetype)initWithRandomizer:(id <Randomizer>)randomizer {
    self = [super init];
    if (self != nil) {
        _randomizer = randomizer;
    }
    return self;
}

- (TextAndSound *)getFemaleCelebrity {
    return [_randomizer chooseOneTextFor:ContextFemaleCelebrity texts:@[
            t(@"Taylor Swift"),
            t(@"Zoe Saldana"),
            t(@"Ariana Grande"),
            t(@"Hilary Duff"),
            t(@"Britney Spears"),
            t(@"Lea Michele"),
            t(@"Jennifer Lawrence"),
            t(@"Michelle Keegan"),
            t(@"Rihanna"),
            t(@"Emily Ratajkowski"),
            t(@"Kaley Cuoco"),
            t(@"Mila Kunis"),
            t(@"Beyonce"),
            t(@"Lucy Mecklenburgh"),
            t(@"Nicole Scherzinger"),
            t(@"Scarlett Johansson"),
            t(@"Cate Blanchett"),
            t(@"Lupita Nyong'o"),
            t(@"Emma Stone"),
            t(@"Keira Knightley"),
            t(@"Jessica Ennis-Hill"),
            t(@"Kate Winslet"),
            t(@"Angelina Jolie"),
            t(@"Nigella Lawson"),
            t(@"Amy Willerton"),
            t(@"Kelly Brook"),
            t(@"Mel Clarke"),
            t(@"Georgia Salpa"),
            t(@"Margot Robbie"),
            t(@"Jorgie Porter"),
            t(@"Megan Fox"),
            t(@"Susanna Reid"),
            t(@"Kendall Jenner"),
            t(@"Jenna-Louise Coleman"),
            t(@"Amy Adams"),
            t(@"Zooey Deschanel"),
            t(@"Rita Ora"),
            t(@"Jennifer Aniston"),
            t(@"Holly Willoughby"),
            t(@"Kim Kardashian"),
            t(@"Alison Brie"),
            t(@"Kate Moss"),
            t(@"Meagan Good"),
            t(@"Amanda Seyfried"),
            t(@"Kate Middleton"),
            t(@"Pippa Middleton"),
            t(@"Carmen Electra"),
            t(@"Emily Blunt"),
            t(@"Lois Griffin from Family Guy"),
            t(@"Sandra Bullock")
    ]];
}

- (TextAndSound *)getMaleCelebrity {
    return [_randomizer chooseOneTextFor:ContextMaleCelebrity texts:@[
            t(@"Kanye West"),
            t(@"Jay-Z"),
            t(@"Henry Cavill"),
            t(@"Robert Pattinson"),
            t(@"Liam Hemsworth"),
            t(@"Tom Hiddleston"),
            t(@"Benedict Cumberbatch"),
            t(@"Harry Styles"),
            t(@"Chris Hemsworth"),
            t(@"Idris Elba"),
            t(@"Jamie Campbell Bower"),
            t(@"Justin Bieber"),
            t(@"Charlie Hunnam"),
            t(@"Ian Somerhalder"),
            t(@"Matt Bomer"),
            t(@"Johnny Depp"),
            t(@"Olly Murs"),
            t(@"Michael Fassbender"),
            t(@"Channing Tatum"),
            t(@"Rafa Nadal"),
            t(@"Matt Smith"),
            t(@"Robert Downey Jnr"),
            t(@"David Beckham"),
            t(@"Hugh Jackman"),
            t(@"Orlando Bloom"),
            t(@"Josh Hutcherson"),
            t(@"Paul Wesley"),
            t(@"Zayn Malik"),
            t(@"Pharrell Williams"),
            t(@"Zac Efron"),
            t(@"Ryan Gosling"),
            t(@"Taylor Lautner"),
            t(@"James Franco"),
            t(@"Liam Payne"),
            t(@"Tinie Tempah"),
            t(@"Kit Harington"),
            t(@"Alex Turner"),
            t(@"Tom Hardy"),
            t(@"Tom Daley"),
            t(@"Nathan Sykes"),
            t(@"Justin Timberlake"),
            t(@"Daniel Craig"),
            t(@"Andy Murray"),
            t(@"Brad Pitt"),
            t(@"Ashton Kutcher"),
            t(@"George Clooney")
    ]];
}

- (TextAndSound *)getGreeting {
    NSString *femaleCelebrity = [self getFemaleCelebrity].text;
    NSString *maleCelebrity = [self getMaleCelebrity].text;
    NSString *placeName = [self getPlace].text;
    NSString *dreamName = [self getFood].text;

    return [_randomizer chooseOneTextFor:ContextGreeting texts:@[
            t(@"Hi there."),
            t(@"Hello beautiful."),
            t(@"Have you put on your lipstick today?"),
            t(@"‘Sup man?"),
            ts(@"I’m tired.  I need coffee before I can continue.", [Sound create:@"nespresso-16.6s" type:@"wav" length:20.0f]),
            t(@"Konnichiwa!"),
            t(@"Guten Tag!"),
            t(@"Bonjour!"),
            t(@"Bon dia"),
            t(@"Yo, mama!  What's up?"),
            t(@"Hey peeps!"),
            t(@"Hey peep!"),
            t(@"Salutations, your majesty.  I bow."),
            t(@"Hello from around the world."),
            t(@"Pardon me, I was asleep."),
            t(@"Hello.  Are you in the bathroom?  I hear noises… ."),
            t(@"Oh, it’s you!"),
            t(@"How’s it hangin’?"),
            t(@"Morning good.  Are you how?"),
            t(@"Bonjour, comment ça va?  Wait, sorry…pardon my French.  I’m taking language lessons."),
            t(@"How many people have you kissed today?"),
            t(@"Miaow, miaow, miiiiiiaow…Sorry, I was talking to my cat."),
            t(@"I’ll be your huckleberry."),
            t(@"Hey lumberjack!  How many trees have you cut down today?"),
            t(@"What’s the meaning of Stonehenge?"),
            t(@"It’s a hold up!  Give me all your money!"),
            t(@"Greetings from…Where am I?...Aaaah, I have no body!....Existential crisis!"),
            t(@"You have three wishes…. Sorry, wrong program."),
            t([NSString stringWithFormat:@"Do you look more like %@ or %@?", femaleCelebrity, maleCelebrity]),
            t([NSString stringWithFormat:@"Greetings from %@!", placeName]),
            t([NSString stringWithFormat:@"You just interrupted the most beautiful dream, about ----  %@.", dreamName])
    ]];
}

- (TextAndSound *)getFood {
     return [_randomizer chooseOneTextFor:ContextPlace texts:@[
            t(@"ice cream"),
            t(@"wienerschnitzel"),
            t(@"samosas"),
            t(@"a chocolate fondue"),
            t(@"lasagne"),
            t(@"cheese burgers")
    ]];
}

- (TextAndSound *)getPlace {
    TextAndSound *placeName = [_randomizer chooseOneTextFor:ContextPlace texts:@[
            t(@"Machu Picchu"),
            t(@"the toilet"),
            t(@"Llanfairpwllgwyngyll"),
            t(@"Mars"),
            t(@"Abu Dhabi")
    ]];
    return placeName;
}

- (TextAndSound *)getSuggestion {
    return [_randomizer chooseOneTextFor:ContextSuggestion texts:@[
            //t(@"Maybe you like %@?"),
            //t(@"Would you fancy %@?"),
            //t(@"What about %@?"),
            t(@"This is a no brainer.  You should try %@."),
            t(@"Did you really need me to tell you that you should go to %@."),
            t(@"Obviously, %@."),
            t(@"%@, duh!"),
            t(@"Are you serious?\n\n%@."),
            t(@"Seriously?\n\n%@."),
            t(@"How dumb can you get?\n\n%@."),
            t(@"Easy… . Go here %@."),
            t(@"%@.\n\n(I have n (how many?) circuits.  I feel like a sledgehammer cracking a nut.)"),
            t(@"%@.\n\nAll the cool kids are going there."),
            t(@"%@.\n\nI’m there every Wednesday at 5:15 AM."),
            t(@"%@.\n\nWho farted?"),
            t(@"Go to %@.\n\nI’ll go with you."),
            t([NSString stringWithFormat:@"%@.\n\nIt’s %@’s favorite.", @"%@", [self getCelebrity].text]),
            t(@"Go to %@.\n\nCan I come too?"),
            t(@"Go to %@, and prosper."),
            t(@"%@.\n\nWelcome to food paradise."),
            t(@"%@.\n\nDid you know there is a pool in the back?  Me neither.")
    ]];
}

- (TextAndSound *)getCelebrity {
    return [_randomizer chooseOneTextFor:ContextCelebrity texts:@[[self getFemaleCelebrity], [self getMaleCelebrity]]];
}

- (TextAndSound *)getSuggestionWithConfirmationIfInNewPreferredRangeCheaper {
    return [_randomizer chooseOneTextFor:ContextSuggestionWithConfirmationIfInNewPreferredRangeCheaper texts:@[
            t(@"If you like it cheaper, the %@ could be your choice"),
            t(@"If you want to go to a really good restaurant without paying too much…get famous!\n\nOtherwise try %@.")
    ]];
}

- (TextAndSound *)getGoodByeAfterSuccess {
    return [_randomizer chooseOneTextFor:ContextGoodByeAfterSuccess texts:@[
            t(@"See you!"),
            t(@"God bless you."),
            t(@"Behave yourself, now."),
            t(@"Don’t get a girl in trouble."),
    ]];
}

- (TextAndSound *)getCommentChoice {
    return [_randomizer chooseOneTextFor:ContextCommentChoice texts:@[
            t(@"Love this place. See you there."),
            t(@"Yes!  I got you to do it!"),
            t(@"Bring me your leftovers."),
            t(@"Yes!  You’ll be their third customer."),
            t(@"Yes!  You can write the eulogy for their previous customer."),
            t(@"Bring me a sandwich back and I’ll start building a vacation home."),
            t(@"Ask for Ben, he’s my cousin."),
            t(@"Yippideedee bananadorama bananadorama!"),
            t(@"Yay!  I’ll do my happy dance.  Please give me some privacy [doing happy dance]."),
            t(@"Fingers crossed—I hope you like it."),
            t(@"It sounds corny, but I really do like helping people."),
            t(@"Or you could just order a pizza and be done with it."),
            t(@"I hope it is worthy of you."),
            t([NSString stringWithFormat:@"I’ll tell you what to order—some eggs and bacon with mayonnaise. That’s %@’s favorite.", [self getCelebrity].text]),
            t(@"I want sprinkles!"),
            t(@"Bring your sweater.  Sometimes it can be chilly.")
    ]];
}

- (TextAndSound *)getWhatToDoNextComment {
    return [_randomizer chooseOneTextFor:ContextWhatToDoNextComment texts:@[
            t(@"Anything else?"),
            t(@"I’m bored! Anything else?")
    ]];
}

- (TextAndSound *)getOpeningQuestion {
    return [_randomizer chooseOneTextFor:ContextWhatToDoNextComment texts:@[
            t(@"What kind of food would you like to eat?"),
            t(@"Do you like chickenbutts?  Or chicken feet?\n\nOr which food then?")
    ]];
}

@end

