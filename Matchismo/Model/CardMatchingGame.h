//
// Created by Ruben Ernst on 17-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Deck;
@class Card;


@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardGameCount:(NSUInteger)count
                            usingDeck:(Deck *)deck
                numberOfMatchingCards:(NSUInteger)numberOfMatchingCards;

- (void)chooseCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@end