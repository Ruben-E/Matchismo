//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ruben Ernst on 11-02-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@end

@implementation CardGameViewController

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flipCount changed to %d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSString *cardImage;
    NSString *cardText;
    if ([sender.currentTitle length]) {
        cardImage = @"cardback";
        cardText = @"";
    } else {
        cardImage = @"cardfront";
        cardText = @"A";
    }

    [sender setBackgroundImage:[UIImage imageNamed: cardImage]
                      forState:UIControlStateNormal];
    [sender setTitle: cardText
            forState:UIControlStateNormal];

    self.flipCount++;
}
@end