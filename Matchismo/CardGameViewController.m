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

static NSUInteger const DEFAULT_NUMBER_OF_MATCHING_CARDS = 2;
static NSString * const DEFAULT_HISTORY_LABEL_TEXT = @"No actions performed";

@interface CardGameViewController ()
// UI
@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *resetButton;
@property(weak, nonatomic) IBOutlet UISegmentedControl *modeSwitcher;
@property(weak, nonatomic) IBOutlet UILabel *historyLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;

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
    NSInteger value = [text integerValue];
    
    if (value) {
        self.numberOfMatchingCards = value;
        [self restartGame];
    }
}

- (IBAction)historySliderChanged:(UISlider *)sender {
    UISlider *slider = (UISlider *)sender;
    NSLog(@"SliderValue ... %d",(int)[slider value]);
    
    [self updateHistoryLabelUIForHistoryIndex:[slider value]];
}

// Helpers

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)restartGame {
    self.game = [self createGame];
    [self updateUI];
}

// UI

- (void)updateUI {
    self.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), self.game.score];

    [self updateModeSwitcherUI];
    [self updateButtonsUI];
    [self updateHistoryLabelUI];
    [self updateHistorySliderUI];
}

- (void)updateModeSwitcherUI {
    if (self.game.flips == 0) {
        [self.modeSwitcher setEnabled:YES];
    } else {
        [self.modeSwitcher setEnabled:NO];
    }
}

- (void)updateButtonsUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
}

- (void)updateHistoryLabelUI {
    History *latestHistory = [self.game.histories lastObject];
    if (latestHistory) {
        NSUInteger latestHistoryId = [self.game.histories indexOfObject:latestHistory];
        
        [self updateHistoryLabelUIForHistoryIndex:latestHistoryId];
    } else {
        [self updateHistoryLabelUIForHistoryIndex:0];
    }
}

- (void)updateHistoryLabelUIForHistoryIndex:(NSUInteger)index {
    NSString *newText = @"";
    
    if([self.game.histories count] > index) {
        History *history = [self.game.histories objectAtIndex:index];
        
        switch (history.action) {
            case toFront:
                newText = [NSString stringWithFormat:@"%@", [[history.cards firstObject] contents]];
                break;
            case toBack:
                newText = NSLocalizedString(@"Card flipped back", @"Kaart omgedraaid");
                break;
            case matched:
                newText = [NSString stringWithFormat:NSLocalizedString(@"Matched %@ for %d points", nil), [Card contentsForCards:history.cards], history.resultScore];
                break;
            case notMatched:
                newText = [NSString stringWithFormat:NSLocalizedString(@"%@ don't match! %d points penalty", nil), [Card contentsForCards:history.cards], history.resultScore];
                break;
        }
    } else {
        newText = [NSString stringWithFormat:DEFAULT_HISTORY_LABEL_TEXT];
    }
    
    
    [self.historyLabel setText:newText];
}

- (void)updateHistorySliderUI {
    if ([self.game.histories count] > 0) {
        [self.historySlider setEnabled:YES];
        [self.historySlider setMaximumValue:([self.game.histories count] - 1)];
        [self.historySlider setMinimumValue:0];
        [self.historySlider setContentScaleFactor:1];
        [self.historySlider setValue:([self.game.histories count] - 1)];
        if ([self.game.histories count] > 1) {
            [self.historySlider setHidden:NO];
        }
    } else {
        [self.historySlider setEnabled:NO];
        [self.historySlider setHidden:YES];
    }
}

// Creators

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)createGame {
    return [[CardMatchingGame alloc] initWithCardGameCount:[self.cardButtons count] usingDeck:[self createDeck] numberOfMatchingCards:[self numberOfMatchingCards]];
}

// Setters / Getters

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


@end