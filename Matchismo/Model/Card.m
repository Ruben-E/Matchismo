//
// Created by Ruben Ernst on 11-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import "Card.h"


@implementation Card {

}
- (int)match:(NSArray *)otherCards {
    int score = 0;

    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }

    return score;
}

+ (NSString *)contentsForCards:(NSArray *)cards {
    NSMutableString *contents = [[NSMutableString alloc] init];
    for (id obj in cards) {
        if ([obj isKindOfClass:[Card class]]) {
            if ([obj contents]) {
                [contents appendString:[obj contents]];
            }
        }
    }

    return contents;
}


@end