//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ruben Ernst on 11-02-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

static NSUInteger const DEFAULT_NUMBER_OF_MATCHING_CARDS = 2;

@interface CardGameViewController ()

@end

@implementation CardGameViewController

// Helpers

- (NSAttributedString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : [[NSAttributedString alloc] initWithString:@""];
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)restartGame {
    self.deck = [self createDeck];
    self.game = [self createGame];
}

- (Deck *)createDeck {
    Class deckClass = [self.deck class];
    Deck *deck = [[deckClass alloc] init];
    
    return deck;
}

- (CardMatchingGame *)createGame {
    return [[CardMatchingGame alloc] initWithCardGameCount:[self.cardButtons count] usingDeck:[self deck] numberOfMatchingCards:[self numberOfMatchingCards]];
}

// Setters / Getters

- (NSUInteger)numberOfMatchingCards {
    if (!_numberOfMatchingCards) {
        _numberOfMatchingCards = DEFAULT_NUMBER_OF_MATCHING_CARDS;
    }

    return _numberOfMatchingCards;
}


- (CardMatchingGame *)game {
    if (!_game) {
        _game = [self createGame];
    }

    return _game;
}

- (NSArray *)cardButtons {
    if (!_cardButtons) {
        _cardButtons = [[NSArray alloc] init];
    }

    return _cardButtons;
}


@end