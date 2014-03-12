//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Ruben Ernst on 06-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()
// UI
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *resetButton;
@property(weak, nonatomic) IBOutlet UILabel *historyLabel;
@property(weak, nonatomic) IBOutlet UISlider *historySlider;

@end

@implementation SetGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.deck = [[SetCardDeck alloc] init];
    self.numberOfMatchingCards = 3;
}

- (void)restartGame {
    [super restartGame];
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
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
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

    if ([self.game.histories count] > index) {
        History *history = [self.game.histories objectAtIndex:index];

        switch (history.action) {
            case toFront:
                newText = [NSString stringWithFormat:@"%@", [[[history.cards firstObject] contents] string]];
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

// Handlers

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)touchResetButton:(UIButton *)sender {
    [self restartGame];
}

- (IBAction)historySliderChanged:(UISlider *)sender {
    NSLog(@"SliderValue ... %d", (int) [sender value]);

    [self updateHistoryLabelUIForHistoryIndex:[sender value]];
}

- (NSString *)titleForCard:(SetCard *)card {
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithAttributedString:[super titleForCard:card]];

    if(![[title string] isEqualToString:@""]) {
        SEL colorSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", card.color]);
        UIColor *color = [UIColor performSelector:colorSelector];

        if([card.shading isEqualToString:@"solid"]) {
            [title addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, card.number)];
        } else if ([card.shading isEqualToString:@"stripped"]) {
            [title addAttribute:NSForegroundColorAttributeName value:[color colorWithAlphaComponent:0.5] range:NSMakeRange(0, card.number)];
        } else {
            [title addAttribute:NSForegroundColorAttributeName value:[color colorWithAlphaComponent:0] range:NSMakeRange(0, card.number)];
        }

        [title addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:-5.0] range:NSMakeRange(0, card.number)];
        [title addAttribute:NSStrokeColorAttributeName value:color range:NSMakeRange(0, card.number)];

        NSLog(@"Content for card: %@", [title string]);
    }

    return title;
}

@end
