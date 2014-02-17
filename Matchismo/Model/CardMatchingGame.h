//
// Created by Ruben Ernst on 17-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Deck;
@class Card;


@interface CardMatchingGame : NSObject
- (instancetype)initWithCardGameCount:(NSUInteger)count
                            usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@end