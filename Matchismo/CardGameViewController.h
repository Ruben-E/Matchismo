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

static NSString *const DEFAULT_HISTORY_LABEL_TEXT = @"No actions performed";

@interface CardGameViewController : UIViewController

// Logic
@property(nonatomic) NSUInteger numberOfMatchingCards;
@property(strong, nonatomic) CardMatchingGame *game;
@property(strong, nonatomic) Deck *deck;

@property(strong, nonatomic) NSMutableArray *cardViews; // Of CardView
@property(weak, nonatomic) IBOutlet UIView *gridView;
@property(weak, nonatomic) IBOutlet UIButton *redealButton;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(nonatomic) NSUInteger cardWidth;
@property(nonatomic) NSUInteger cardHeight;
@property(nonatomic) NSUInteger initialCards;
@property(nonatomic) BOOL cardsShouldFlip;
@property(nonatomic) BOOL removeMatchedCards;
@property(strong, nonatomic) UIDynamicAnimator *pileAnimation;

- (CardMatchingGame *)game;

- (void)restartGame;

- (void)updateUI;

- (void)moveCardViewsToOriginalPosition:(NSArray *)cardViews;
@end