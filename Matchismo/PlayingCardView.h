//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Ruben Ernst on 02-04-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property(nonatomic) NSUInteger rank;
@property(strong, nonatomic) NSString *suit;
@property(nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
