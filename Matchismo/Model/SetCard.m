//
//  SetCard.m
//  Matchismo
//
//  Created by Ruben Ernst on 06-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "SetCard.h"

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
        return 1;
    }

    return 0;
}


+ (NSArray *)validSymbols {
    return @[@"▲", @"■", @"●"];
}

+ (NSArray *)validShadings {
    return @[@"open", @"stripped", @"solid"];
}

+ (NSArray *)validColors {
    return @[@"red", @"purple", @"green"];
}

+ (NSUInteger)maxNumber {
    return 3;
}


@end
