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
#import "HistoryViewController.h"
#import "SetCardView.h"

@interface SetGameViewController ()
// UI
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *resetButton;
@property(weak, nonatomic) IBOutlet UILabel *historyLabel;
@property(weak, nonatomic) IBOutlet UISlider *historySlider;
@property(weak, nonatomic) IBOutlet SetCardView *setCardView;
@property(weak, nonatomic) IBOutlet UIButton *dealMoreCardsButton;

@end

@implementation SetGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.deck = [[SetCardDeck alloc] init];
    self.numberOfMatchingCards = 3;

    self.setCardView.symbol = @"oval";
    self.setCardView.shading = @"striped";
    self.setCardView.color = @"red";
    self.setCardView.number = 2;
    self.removeMatchedCards = YES;

    self.initialCards = 12;
    self.cardWidth = 60;
    self.cardHeight = 80;
    [self updateUI];
}

//- (void)updateButtonsUI {
//    for (UIButton *cardButton in self.cardButtons) {
//        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
//        Card *card = [self.game cardAtIndex:cardButtonIndex];
//        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
//        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
//        cardButton.enabled = !card.isMatched;
//    }
//}
//
//- (void)updateHistoryLabelUI {
//    History *latestHistory = [self.game.histories lastObject];
//    if (latestHistory) {
//        NSUInteger latestHistoryId = [self.game.histories indexOfObject:latestHistory];
//
//        [self updateHistoryLabelUIForHistoryIndex:latestHistoryId];
//    } else {
//        [self updateHistoryLabelUIForHistoryIndex:0];
//    }
//}
//
//- (void)updateHistoryLabelUIForHistoryIndex:(NSUInteger)index {
//    NSString *newText = @"";
//
//    if ([self.game.histories count] > index) {
//        History *history = [self.game.histories objectAtIndex:index];
//
//        switch (history.action) {
//            case toFront:
//                newText = [NSString stringWithFormat:@"%@", [[[history.cards firstObject] contents] string]];
//                break;
//            case toBack:
//                newText = NSLocalizedString(@"Card flipped back", @"Kaart omgedraaid");
//                break;
//            case matched:
//                newText = [NSString stringWithFormat:NSLocalizedString(@"Matched %@ for %d points", nil), [Card contentsForCards:history.cards], history.resultScore];
//                break;
//            case notMatched:
//                newText = [NSString stringWithFormat:NSLocalizedString(@"%@ don't match! %d points penalty", nil), [Card contentsForCards:history.cards], history.resultScore];
//                break;
//        }
//    } else {
//        newText = [NSString stringWithFormat:DEFAULT_HISTORY_LABEL_TEXT];
//    }
//
//
//    [self.historyLabel setText:newText];
//}

// Handlers

- (IBAction)touchDealMoreCardsButton:(UIButton *)sender {
    for (int i = 0; i < 3; i++) {
        [self.game dealCard];
    }

    [self updateUI];
}

- (IBAction)touchResetButton:(UIButton *)sender {
    [self restartGame];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showHistory"]) {
        HistoryViewController *destViewController = segue.destinationViewController;
        destViewController.game = [self game];
    }
}

- (UIView *)getCardView:(UIView *)view forCard:(Card *)card {
    if ([card isKindOfClass:[SetCard class]]) {
        SetCardView *cardView = (SetCardView *) view;
        if (!cardView) {
            cardView = [[SetCardView alloc] init];
        }

        SetCard *setCard = (SetCard *) card;
        cardView.number = setCard.number;
        cardView.symbol = setCard.symbol;
        cardView.shading = setCard.shading;
        cardView.color = setCard.color;
        cardView.chosen = setCard.chosen;

        return cardView;
    }

    return nil;
}

@end
