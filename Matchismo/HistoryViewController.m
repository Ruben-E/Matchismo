//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Ruben Ernst on 12-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "HistoryViewController.h"
#import "Card.h"

static NSString *const DEFAULT_HISTORY_LABEL_TEXT = @"No actions performed";

@interface HistoryViewController ()
@property(weak, nonatomic) IBOutlet UITextView *historyLabel;
@property(weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateHistorySliderUI];
    [self updateHistoryLabelUIForHistoryIndex:([self.game.histories count] - 1)];
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

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
}

- (IBAction)historySliderChanged:(UISlider *)sender {
    NSLog(@"SliderValue ... %d", (int) [sender value]);

    [self updateHistoryLabelUIForHistoryIndex:[sender value]];
}

@end
