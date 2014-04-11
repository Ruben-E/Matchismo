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
    [self updateUI];

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

@end
