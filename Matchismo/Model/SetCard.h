//
//  SetCard.h
//  Matchismo
//
//  Created by Ruben Ernst on 06-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

+ (NSArray *)validSymbols;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

+ (NSUInteger)maxNumber;

@end
