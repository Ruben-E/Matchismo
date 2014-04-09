//
// Created by Ruben Ernst on 11-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import "Card.h"
#import "SetCard.h"


@implementation Card {

}
- (int)match:(NSArray *)otherCards {
    int score = 0;

    for (Card *card in otherCards) {
        if ([card.contents isEqualToAttributedString:self.contents]) {
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
                if ([[obj contents] isKindOfClass:[NSAttributedString class]]) {
                    [contents appendString:[[obj contents] string]];
                } else if ([[obj contents] isKindOfClass:[NSString class]]) {
                    [contents appendString:[obj contents]];
                }
            }
        }
    }

    return contents;
}


@end