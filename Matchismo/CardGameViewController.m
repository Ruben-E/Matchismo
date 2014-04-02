//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ruben Ernst on 11-02-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "Grid.h"
#import "SetCard.h"
#import "PlayingCard.h"
#import "SetCardView.h"

static NSUInteger const DEFAULT_NUMBER_OF_MATCHING_CARDS = 2;

@interface CardGameViewController ()
@property(strong, nonatomic) NSMutableArray *cardViews; // Of CardView
@property(strong, nonatomic) Grid *grid;
@end

@implementation CardGameViewController

// Helpers

- (NSAttributedString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents : [[NSAttributedString alloc] initWithString:@""];
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)restartGame {
    self.deck = [self createDeck];
    self.game = [self createGame];
    [self resetCardViews];
    [self updateUI];
}

- (Deck *)createDeck {
    Class deckClass = [self.deck class];
    Deck *deck = [[deckClass alloc] init];

    return deck;
}

- (CardMatchingGame *)createGame {
    return [[CardMatchingGame alloc] initWithCardGameCount:[self initialCards] usingDeck:[self deck] numberOfMatchingCards:[self numberOfMatchingCards]];
}

- (Grid *)createGrid {
    Grid *grid = [[Grid alloc] init];
    grid.cellAspectRatio = 0.75;
    grid.minimumNumberOfCells = self.game.cards.count ? self.game.cards.count : self.initialCards;
    grid.maxCellWidth = self.cardWidth;
    grid.maxCellHeight = self.cardHeight;
    grid.size = self.gridView.bounds.size;

    return grid;

}

- (void)recalculateGrid {
    _grid = [self createGrid];
}

- (void)resetCardViews {
    for (NSUInteger i = 0; i < [self.cardViews count]; i++) {
        id obj = [self.cardViews objectAtIndex:i];
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *) obj;
            [view removeFromSuperview];
        }
    }

    self.cardViews = [[NSMutableArray alloc] init];
}

- (UIView *)cardViewForIndex:(NSUInteger)index {
    for (NSUInteger i = 0; i < [self.cardViews count]; i++) {
        id obj = [self.cardViews objectAtIndex:i];
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *) obj;
            if (view.tag == index) {
                return view;
            }
        }
    }

    return nil;
}

- (UIView *)getCardView:(UIView *)view forCard:(Card *)card // Abstract
{
    return nil;
}

- (void)touchCard:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        Card *card = [self.game cardAtIndex:gesture.view.tag];
        if (!card.matched) {
            if (self.cardsShouldFlip) {
                [UIView transitionWithView:gesture.view
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                    card.chosen = !card.chosen;
                    [self getCardView:gesture.view forCard:card];
                }               completion:^(BOOL finished) {
                    card.chosen = !card.chosen;
                    [self.game chooseCardAtIndex:gesture.view.tag];
                    [self updateUI];
                }];
            } else {
                [self.game chooseCardAtIndex:gesture.view.tag];
                [self updateUI];
            }
        }
    }
}

#define FLY_OUT_ANIMATION_DURATION 1.2
#define FLY_IN_ANIMATION_DURATION 1.2

- (void)updateUI {
    [self recalculateGrid];
    [self updateScoreLabel];

    NSMutableArray *newViews = [[NSMutableArray alloc] init];

    for (NSUInteger i = 0; i < [self.game.cards count]; i++) {
        Card *card = [self.game cardAtIndex:i];
        UIView *cardView = [self cardViewForIndex:i];
        if (!cardView) {
            cardView = [self getCardView:nil forCard:card];
            cardView.backgroundColor = [UIColor clearColor];
            cardView.tag = i;

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(touchCard:)];
            [cardView addGestureRecognizer:tap];

            [newViews addObject:cardView];
            [self.cardViews addObject:cardView];
        }
        if (![card isMatched]) {
            cardView = [self getCardView:cardView forCard:card];

            CGRect frame = [self.grid frameOfCellAtRow:cardView.tag / self.grid.columnCount
                                              inColumn:cardView.tag % self.grid.columnCount];
            frame = CGRectInset(frame, frame.size.width * 0.05, frame.size.height * 0.05);

            if (![self frame:cardView.frame matchesFrame:frame]) {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     cardView.frame = frame;
                                 } completion:NULL];
            }
        } else {
            if (self.removeMatchedCards) {
                [self.cardViews removeObject:cardView];
                [UIView animateWithDuration:FLY_OUT_ANIMATION_DURATION
                                 animations:^{
                                     cardView.frame = CGRectMake(0.0 - cardView.bounds.size.width, self.gridView.superview.bounds.size.height - cardView.bounds.size.height, cardView.bounds.size.width, cardView.bounds.size.height);
                                 } completion:^(BOOL finished) {
                    [cardView removeFromSuperview];
                }];
            } else {
                if (card.isMatched) {
                    cardView.alpha = 0.6;
                } else {
                    cardView.alpha = 1.0;
                }
            }
        }
    }

//  FLY IN ANIMATIE

    for (NSUInteger viewIndex = 0; viewIndex < [newViews count]; viewIndex++) {
        UIView *cardView = (UIView *) newViews[viewIndex];
        [self.gridView addSubview:cardView];

        CGPoint differenceBetweenSuperview = [self.gridView.superview convertPoint:self.gridView.frame.origin toView:nil];

        cardView.frame = CGRectMake(0.0 - differenceBetweenSuperview.x - cardView.bounds.size.width,
                0.0 - differenceBetweenSuperview.y - cardView.bounds.size.height,
                cardView.bounds.size.width,
                cardView.bounds.size.height);

        CGRect frame = [self.grid frameOfCellAtRow:cardView.tag / self.grid.columnCount
                                          inColumn:cardView.tag % self.grid.columnCount];
        frame = CGRectInset(frame, frame.size.width * 0.05, frame.size.height * 0.05);

        [UIView animateWithDuration:0.5
                              delay:1.5 * viewIndex / [self.cardViews count]
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             cardView.frame = frame;
                         } completion:NULL];
    }
}

- (BOOL)frame:(CGRect)frame1 matchesFrame:(CGRect)frame2 {
    if (frame1.size.width == frame2.size.width && frame1.size.height == frame2.size.height) {
        return YES;
    }

    return NO;
}

- (void)updateScoreLabel {
    self.scoreLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Score: %d", nil), self.game.score];
}

- (IBAction)touchRedealButton:(UIButton *)sender {
    [self restartGame];
    [self updateUI];
}

// Setters / Getters

- (NSUInteger)numberOfMatchingCards {
    if (!_numberOfMatchingCards) {
        _numberOfMatchingCards = DEFAULT_NUMBER_OF_MATCHING_CARDS;
    }

    return _numberOfMatchingCards;
}


- (CardMatchingGame *)game {
    if (!_game) {
        _game = [self createGame];
    }

    return _game;
}

- (NSArray *)cardButtons {
    if (!_cardButtons) {
        _cardButtons = [[NSArray alloc] init];
    }

    return _cardButtons;
}

- (Grid *)grid {
    if (!_grid) {
        _grid = [self createGrid];
    }

    return _grid;
}

- (NSMutableArray *)cardViews {
    if (!_cardViews) {
        _cardViews = [[NSMutableArray alloc] init];
    }
    return _cardViews;
}


@end