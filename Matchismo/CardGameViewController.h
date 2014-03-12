//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Ruben Ernst on 11-02-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//
// Abstract class

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

static NSString * const DEFAULT_HISTORY_LABEL_TEXT = @"No actions performed";

@interface CardGameViewController : UIViewController

// UI
@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

// Logic
@property(nonatomic) NSUInteger numberOfMatchingCards;
@property(strong, nonatomic) CardMatchingGame *game;
@property(strong, nonatomic) Deck *deck;

- (CardMatchingGame *)game;
- (NSArray *)cardButtons;
- (NSString *)titleForCard:(Card *)card;
- (UIImage *)backgroundImageForCard:(Card *)card;
- (void)restartGame;
@end