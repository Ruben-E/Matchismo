//
// Created by Ruben Ernst on 17-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "History.h"

@class Deck;
@class Card;


@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardGameCount:(NSUInteger)count
                            usingDeck:(Deck *)deck
                numberOfMatchingCards:(NSUInteger)numberOfMatchingCards;

- (void)chooseCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

- (void)dealCard;

@property(nonatomic, readonly) NSInteger score;
@property(nonatomic, readonly) NSUInteger flips;
@property(nonatomic, readonly) Deck *deck;
@property(strong, nonatomic, readonly) NSMutableArray *cards; // Of Card
@property(nonatomic, readonly) NSMutableArray *histories; // of History
@end