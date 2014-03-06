//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Ruben Ernst on 11-02-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//
// Abstract class

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// Protected
// for subclasses
- (Deck *)createDeck;       // Abstract
@end