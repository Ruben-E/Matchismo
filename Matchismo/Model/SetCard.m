//
//  SetCard.m
//  Matchismo
//
//  Created by Ruben Ernst on 06-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards {
    return [super match:otherCards];
}

- (NSString *)contents {
    return @"";
}


+ (NSArray *)validSymbols {
    return @[@"▲", @"■", @"●"];
}

+ (NSArray *)validShadings {
    return @[@"open", @"stripped", @"solid"];
}

+ (NSArray *)validColors {
    return @[@"red", @"purple", @"green"];
}

+ (NSUInteger)maxNumber {
    return 3;
}



@end
