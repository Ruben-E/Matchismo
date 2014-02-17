//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ruben Ernst on 11-02-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property(weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property(nonatomic) int flipCount;
@property(nonatomic) Deck *deck;
@end

@implementation CardGameViewController

- (IBAction)touchCardButton:(UIButton *)sender {
    NSString *cardImage;
    NSString *cardText;
    if ([sender.currentTitle length]) {
        cardImage = @"cardback";
        cardText = @"";
    } else {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            cardImage = @"cardfront";
            cardText = [card contents];
        }
    }

    if (cardText) {
        [sender setBackgroundImage:[UIImage imageNamed:cardImage]
                          forState:UIControlStateNormal];
        [sender setTitle:cardText
                forState:UIControlStateNormal];

        self.flipCount++;
    }
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flipCount changed to %d", self.flipCount);
}

- (Deck *)deck {
    if (!_deck) {
        _deck = [self createDeck];
    }

    return _deck;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}
@end