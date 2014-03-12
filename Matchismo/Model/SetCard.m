//
//  SetCard.m
//  Matchismo
//
//  Created by Ruben Ernst on 06-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards {
    return [super match:otherCards];
}

- (NSAttributedString *)contents {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@""];

    for (int i = 0; i < self.number; i++) {
        NSMutableAttributedString *symbolString = [[NSMutableAttributedString alloc] initWithString:self.symbol];
        [string appendAttributedString:symbolString];
    }

    SEL colorSelector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", self.color]);
    UIColor *color = [UIColor performSelector:colorSelector];


    [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.number)];

    return string;
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
