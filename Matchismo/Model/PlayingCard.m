//
// Created by Ruben Ernst on 11-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import "PlayingCard.h"

static NSUInteger const PARTIAL_MATCH_RANKS_SCORE = 3;
static NSUInteger const PARTIAL_MATCH_SUITS_SCORE = 1;
static NSUInteger const FULL_MATCH_RANKS_SCORE = 6;
static NSUInteger const FULL_MATCH_SUITS_SCORE = 2;

@implementation PlayingCard {

}

@synthesize suit = _suit;

- (NSAttributedString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [[NSAttributedString alloc] initWithString:[rankStrings[self.rank] stringByAppendingString:self.suit]];
}

- (int)match:(NSArray *)otherCards {
    NSLog(@"otherCards count: %d", [otherCards count]);

    if ([otherCards count] > 1) {
        NSInteger differentSuits = [self numberOfDifferentSuitsForCards:otherCards];
        NSInteger differentRanks = [self numberOfDifferentRanksForCards:otherCards];

        return [self calculatePointsForNumberOfCards:[otherCards count] numberOfDifferentSuits:differentSuits NumberOfDifferentRanks:differentRanks];
    }

    return 0;
}

- (int)numberOfDifferentRanksForCards:(NSArray *)cards {
    NSMutableSet *ranks = [[NSMutableSet alloc] init];

    for (PlayingCard *card in cards) {
        [ranks addObject:[NSNumber numberWithUnsignedInteger:card.rank]];
    }

    return [ranks count];
}

- (int)numberOfDifferentSuitsForCards:(NSArray *)cards {
    NSMutableSet *suits = [[NSMutableSet alloc] init];

    for (PlayingCard *card in cards) {
        [suits addObject:card.suit];
    }

    return [suits count];
}

- (int)calculatePointsForNumberOfCards:(NSUInteger)numberOfCards
                numberOfDifferentSuits:(NSUInteger)numberOfDifferentSuits
                NumberOfDifferentRanks:(NSUInteger)numberOfDifferentRanks {
    int score = 0;

    // For partial match
    if (numberOfCards >= 3) {
        if (numberOfDifferentRanks == 2) {
            score = PARTIAL_MATCH_RANKS_SCORE * (numberOfCards - 1);
        } else if (numberOfDifferentSuits == 2) {
            score = PARTIAL_MATCH_SUITS_SCORE * (numberOfCards - 1);
        }
    }

    // Full match
    if (numberOfDifferentRanks == 1) {
        score = FULL_MATCH_RANKS_SCORE * (numberOfCards - 1);
    } else if (numberOfDifferentSuits == 1) {
        score = FULL_MATCH_SUITS_SCORE * (numberOfCards - 1);
    }

    return score;
}


+ (NSArray *)validSuits {
    return @[@"♠︎", @"♥", @"︎♣", @"︎♦︎"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

@end