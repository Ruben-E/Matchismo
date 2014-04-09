//
//  SetCard.m
//  Matchismo
//
//  Created by Ruben Ernst on 06-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "SetCard.h"

static NSUInteger const FULL_MATCH_SCORE = 10;

@implementation SetCard

- (NSAttributedString *)contents {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];

    for (int i = 0; i < self.number; i++) {
        NSMutableAttributedString *symbolString = [[NSMutableAttributedString alloc] initWithString:self.symbol];
        [string appendAttributedString:symbolString];
    }

    return string;
}

- (int)match:(NSArray *)otherCards {
    NSLog(@"otherCards count: %d", [otherCards count]);

    if ([otherCards count] > 1) {
        NSMutableArray *numbers = [[NSMutableArray alloc] init]; // Of NSObject
        NSMutableArray *symbols = [[NSMutableArray alloc] init]; // Of NSObject
        NSMutableArray *shadings = [[NSMutableArray alloc] init]; // Of NSObject
        NSMutableArray *colors = [[NSMutableArray alloc] init]; // Of NSObject

        for (SetCard *card in otherCards) {
            [numbers addObject:[NSNumber numberWithUnsignedInteger:card.number]];
            [symbols addObject:card.symbol];
            [shadings addObject:card.shading];
            [colors addObject:card.color];
        }

        NSInteger uniqueNumbers = [self numberOfUniqueItems:numbers];
        NSInteger uniqueSymbols = [self numberOfUniqueItems:symbols];
        NSInteger uniqueShadings = [self numberOfUniqueItems:shadings];
        NSInteger uniqueColors = [self numberOfUniqueItems:colors];

        return [self calculatePointsForNumberOfCards:[otherCards count] uniqueNumbers:uniqueNumbers uniqueSymbols:uniqueSymbols uniqueShadings:uniqueShadings uniqueColors:uniqueColors];
    }

    return 0;
}

- (int)numberOfUniqueItems:(NSArray *)items {
    NSMutableSet *contents = [[NSMutableSet alloc] init];

    for (NSObject *item in items) {
        [contents addObject:item];
    }

    return [contents count];
}

- (int)calculatePointsForNumberOfCards:(NSUInteger)numberOfCards
                         uniqueNumbers:(NSUInteger)uniqueNumbers
                         uniqueSymbols:(NSUInteger)uniqueSymbols
                        uniqueShadings:(NSUInteger)uniqueShadings
                          uniqueColors:(NSUInteger)uniqueColors {
    int score = 0;

    if ((uniqueNumbers == 3 || uniqueNumbers == 1) &&
            (uniqueSymbols == 3 || uniqueSymbols == 1) &&
            (uniqueShadings == 3 || uniqueShadings == 1) &&
            (uniqueColors == 3 || uniqueColors == 1)) {

        score = FULL_MATCH_SCORE;
    }

    return score;
}


+ (NSArray *)validSymbols {
    return @[@"squiggle", @"oval", @"diamond"];
}

+ (NSArray *)validShadings {
    return @[@"open", @"striped", @"solid"];
}

+ (NSArray *)validColors {
    return @[@"red", @"purple", @"green"];
}

+ (NSUInteger)maxNumber {
    return 3;
}


@end
