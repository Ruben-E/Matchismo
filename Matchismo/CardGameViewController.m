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
// UI
@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *resetButton;
@property(weak, nonatomic) IBOutlet UISegmentedControl *modeSwitcher;
@property(weak, nonatomic) IBOutlet UILabel *historyLabel;

// Logic
@property(strong, nonatomic) CardMatchingGame *game;
@property(nonatomic) NSUInteger numberOfMatchingCards;
@end

@implementation CardGameViewController

// Handlers

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

// UI

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), self.game.score];

    if (self.game.flips == 0) {
        [self.modeSwitcher setEnabled:YES];
    } else {
        [self.modeSwitcher setEnabled:NO];
    }

    [self updateHistoryUI];
}

- (void)updateHistoryUI {
    History *latestHistory = [self.game.histories lastObject];
    if (latestHistory) {
        NSString *newText = @"";
        switch (latestHistory.action) {
            case toFront:
                newText = [NSString stringWithFormat:@"%@", [[latestHistory.cards firstObject] contents]];
                break;
            case toBack:
                newText = NSLocalizedString(@"Card flipped back", @"Kaart omgedraaid");
                break;
            case matched:
                newText = [NSString stringWithFormat:NSLocalizedString(@"Matched %@ for %d points", nil), [Card contentsForCards:latestHistory.cards], latestHistory.resultScore];
                break;
            case notMatched:
                newText = [NSString stringWithFormat:NSLocalizedString(@"%@ don't match! %d points penalty", nil), [Card contentsForCards:latestHistory.cards], latestHistory.resultScore];
                break;
        }

        [self.historyLabel setText:newText];
    }
}

// Creators

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)createGame {
    return [[CardMatchingGame alloc] initWithCardGameCount:[self.cardButtons count] usingDeck:[self createDeck] numberOfMatchingCards:[self numberOfMatchingCards]];
}

// Setters

- (NSArray *)cardButtons {
    if (!_cardButtons) {
        _cardButtons = [[NSArray alloc] init];
    }

    return _cardButtons;
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

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


@end