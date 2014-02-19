//
// Created by Ruben Ernst on 18-02-14.
// Copyright (c) 2014 ruben. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum Action {
    toFront,
    toBack,
    matched,
    notMatched
} Action;

@interface History : NSObject
@property(nonatomic, strong) NSArray *cards;
@property(nonatomic) NSInteger resultScore;
@property(nonatomic) NSInteger totalScore;
@property(nonatomic) NSUInteger totalFlips;
@property(nonatomic, assign) enum Action action;

@end