//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Ruben Ernst on 06-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "HistoryViewController.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()
// UI
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *resetButton;
@property(weak, nonatomic) IBOutlet UISegmentedControl *modeSwitcher;
@property(weak, nonatomic) IBOutlet UILabel *historyLabel;
@property(weak, nonatomic) IBOutlet UISlider *historySlider;
@property(weak, nonatomic) IBOutlet UIView *gridView;
@end

@implementation PlayingCardGameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.deck = [[PlayingCardDeck alloc] init];

    self.numberOfMatchingCards = 2;
    self.removeMatchedCards = NO;
    self.cardsShouldFlip = YES;

    self.initialCards = 24;
    self.cardWidth = 60;
    self.cardHeight = 80;
}

- (IBAction)changeNumberofMatchingCards:(UISegmentedControl *)sender {
    NSString *text = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
    NSInteger value = [text integerValue];

    if (value) {
        self.numberOfMatchingCards = value;
        [self restartGame];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showHistory"]) {
        HistoryViewController *destViewController = segue.destinationViewController;
        destViewController.game = [self game];
    }
}

- (UIView *)getCardView:(UIView *)view forCard:(Card *)card {
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCardView *cardView = (PlayingCardView *) view;
        if (!cardView) {
            cardView = [[PlayingCardView alloc] init];
        }

        PlayingCard *playingCard = (PlayingCard *) card;
        
        BOOL newFaceup = playingCard.chosen || playingCard.matched;
        
        if (cardView.faceUp && (cardView.faceUp != newFaceup)) {
            [UIView transitionWithView:cardView
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:NULL
                            completion:NULL];
        }
        
        cardView.suit = playingCard.suit;
        cardView.rank = playingCard.rank;
        cardView.faceUp = playingCard.chosen || playingCard.matched;

        return cardView;
    }

    return nil;
}

@end
