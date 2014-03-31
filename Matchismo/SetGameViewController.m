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
    
    self.initialCards = 12;
    self.cardWidth = 60;
    self.cardHeight = 60;
    [self updateUI];
}

- (void)restartGame {
    [super restartGame];
    [self updateUI];
}

// UI

- (void)updateUI {
//    self.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), self.game.score];
//
//    [self updateButtonsUI];
//    [self updateHistoryLabelUI];
    [super updateUI];
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

// Handlers

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)touchResetButton:(UIButton *)sender {
    [self restartGame];
}

- (NSAttributedString *)titleForCard:(SetCard *)card {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showHistory"]) {
        HistoryViewController *destViewController = segue.destinationViewController;
        destViewController.game = [self game];
    }
}

-(UIView *)getCardView:(UIView *)view forCard:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]]) {
        SetCardView *cardView = (SetCardView *)view;
        if (!cardView) {
            cardView = [[SetCardView alloc] init];
        }
        
        SetCard *setCard = (SetCard *)card;
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
