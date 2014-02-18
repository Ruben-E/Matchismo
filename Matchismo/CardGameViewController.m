//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ruben Ernst on 11-02-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

static const NSUInteger DEFAULT_NUMBER_OF_MATCHING_CARDS = 2;

@interface CardGameViewController ()
@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property(strong, nonatomic) CardMatchingGame *game;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(nonatomic) NSUInteger numberOfMatchingCards;
@end

@implementation CardGameViewController

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)touchResetButton:(UIButton *)sender {
    [self restartGame];
}

- (IBAction)changeNumberofMatchingCards:(UISegmentedControl *)sender {
    NSString *text = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
    if ([text isEqualToString:@"2"]) {
        self.numberOfMatchingCards = 2;
    } else if ([text isEqualToString:@"3"]) {
        self.numberOfMatchingCards = 3;
    }
    [self restartGame];
}

- (void)restartGame {
    self.game = [self createGame];
    [self updateUI];
}

- (NSArray *)cardButtons {
    if (!_cardButtons) {
        _cardButtons = [[NSArray alloc] init];
    }

    return _cardButtons;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)createGame {
    return [[CardMatchingGame alloc] initWithCardGameCount:[self.cardButtons count] usingDeck:[self createDeck] numberOfMatchingCards:[self numberOfMatchingCards]];
}

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

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end