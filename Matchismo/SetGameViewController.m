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
    self.setCardView.number = 2;
    self.removeMatchedCards = YES;

    self.initialCards = 12;
    self.cardWidth = 60;
    self.cardHeight = 80;
    [self updateUI];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    [self updateUI];
}

// Handlers

- (IBAction)touchDealMoreCardsButton:(UIButton *)sender {
    for (int i = 0; i < 3; i++) {
        [self.game dealCard];
    }

    if (self.pileAnimation) {
        self.pileAnimation = nil;
        [self moveCardViewsToOriginalPosition:self.cardViews];
    }

    [self updateUI];
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
