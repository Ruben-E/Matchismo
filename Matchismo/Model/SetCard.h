//
//  SetCard.h
//  Matchismo
//
//  Created by Ruben Ernst on 06-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property(strong, nonatomic) NSString *symbol;
@property(strong, nonatomic) NSString *shading;
@property(strong, nonatomic) NSString *color;
@property(nonatomic) NSUInteger number;

+ (NSArray *)validSymbols;

+ (NSArray *)validShadings;

+ (NSArray *)validColors;

+ (NSUInteger)maxNumber;

@end
