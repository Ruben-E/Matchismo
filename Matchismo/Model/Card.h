//
// Created by Ruben Ernst on 11-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Card : NSObject

@property(strong, nonatomic) NSAttributedString *contents;

@property(nonatomic, getter=isChosen) BOOL chosen;
@property(nonatomic, getter=isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

+ (NSAttributedString *)contentsForCards:(NSArray *)cards;

@end