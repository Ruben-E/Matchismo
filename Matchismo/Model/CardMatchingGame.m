//
// Created by Ruben Ernst on 17-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Deck.h"


@interface CardMatchingGame ()
@property(nonatomic, readwrite) NSInteger score;
@property(nonatomic, readwrite) NSUInteger flips;
@property(nonatomic, readwrite) NSMutableArray *histories;
@property(strong, nonatomic, readwrite) NSMutableArray *cards; // Of Card
@property(nonatomic) NSUInteger numberOfMatchingCards;
@end

@implementation CardMatchingGame {

}
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOSE = 1;

- (instancetype)initWithCardGameCount:(NSUInteger)count usingDeck:(Deck *)deck numberOfMatchingCards:(NSUInteger)numberOfMatchingCards {
    self = [super init];

    if (self) {
        self.numberOfMatchingCards = numberOfMatchingCards;

        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }

    return self;
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];

    self.flips++;

    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self addAction:toBack toHistoryforCards:@[card] withResultScore:0];
        } else {
            NSMutableArray *chosenCards = [[NSMutableArray alloc] init]; // of Card
            card.chosen = YES;

            self.score -= COST_TO_CHOSE;

            [self addAction:toFront toHistoryforCards:chosenCards withResultScore:0];


            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [chosenCards addObject:otherCard];

                    if ([chosenCards count] == self.numberOfMatchingCards) {
                        break;
                    }
                }
            }

            if ([chosenCards count] == self.numberOfMatchingCards) {

                int matchScore = [card match:chosenCards];
                if (matchScore) {
                    NSInteger resultScore = matchScore * MATCH_BONUS;

                    for (Card *chosenCard in chosenCards) {
                        chosenCard.matched = YES;
                    }

                    self.score += resultScore;

                    [self addAction:matched toHistoryforCards:chosenCards withResultScore:resultScore];
                } else {
                    NSInteger resultScore = MISMATCH_PENALTY;

                    for (Card *chosenCard in chosenCards) {
                        chosenCard.matched = NO;
                        chosenCard.chosen = NO;
                    }

                    card.chosen = YES;
                    self.score -= resultScore;

                    [self addAction:notMatched toHistoryforCards:chosenCards withResultScore:resultScore];
                }
            }
        }
    }
}

- (void)addAction:(enum Action)action toHistoryforCards:(NSArray *)cards withResultScore:(int)resultScore {
    History *history = [[History alloc] init];
    history.action = action;
    history.cards = cards;
    history.resultScore = resultScore;
    history.totalScore = self.score;
    history.totalFlips = self.flips;

    [self.histories addObject:history];
}

- (Card *)cardAtIndex:(NSUInteger)index {
    if (index < [self.cards count]) {
        return self.cards[index];
    } else {
        return nil;
    }
}

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }

    return _cards;
}

- (NSMutableArray *)histories {
    if (!_histories) {
        _histories = [[NSMutableArray alloc] init];
    }

    return _histories;
}


@end