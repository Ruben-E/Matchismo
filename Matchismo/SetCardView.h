//
//  SetCardView.h
//  Matchismo
//
//  Created by Ruben Ernst on 29-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property(nonatomic, strong) NSString *color;
@property(nonatomic, strong) NSString *symbol;
@property(nonatomic, strong) NSString *shading;
@property(nonatomic) NSUInteger number;

@property(nonatomic) BOOL chosen;

@end
