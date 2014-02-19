//
// Created by Ruben Ernst on 11-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import "PlayingCard.h"


@implementation PlayingCard {

}

@synthesize suit = _suit;

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (int)match:(NSArray *)otherCards {
    int score = 0;

    if ([otherCards count] > 1) {
        NSMutableSet *ranks = [[NSMutableSet alloc] init];
        NSMutableSet *suits = [[NSMutableSet alloc] init];
        for (PlayingCard *otherCard in otherCards) {
            [ranks addObject:[NSNumber numberWithUnsignedInteger:otherCard.rank]];
            [suits addObject:otherCard.suit];
        }

        if ([ranks count] == 1) {
            score = 4 * [otherCards count] - 1;
        } else if ([suits count] == 1) {
            score = 1 * [otherCards count] - 1;
        }
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