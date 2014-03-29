//
//  SetCardView.m
//  Matchismo
//
//  Created by Ruben Ernst on 29-03-14.
//  Copyright (c) 2014 ruben. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Properties

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }



- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawSymbols];
}

#define SYMBOL_OFFSET 0.25;
#define SYMBOL_LINE_WIDTH 0.015;
#define SYMBOL_WIDTH 0.7
#define SYMBOL_HEIGHT 0.175

- (void)drawSymbols
{
    CGFloat offset = self.bounds.size.height * SYMBOL_OFFSET;
    CGPoint centerPoint = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    if (self.number == 1) {
        [self drawSymbolAtPoint:centerPoint];
    } else if (self.number == 2) {
        [self drawSymbolAtPoint:CGPointMake(centerPoint.x, centerPoint.y - (offset / 2))];
        [self drawSymbolAtPoint:CGPointMake(centerPoint.x, centerPoint.y + (offset / 2))];
    } else if (self.number == 3) {
        [self drawSymbolAtPoint:centerPoint];
        [self drawSymbolAtPoint:CGPointMake(centerPoint.x, centerPoint.y - offset)];
        [self drawSymbolAtPoint:CGPointMake(centerPoint.x, centerPoint.y + offset)];
    }
}

- (void)drawSymbolAtPoint:(CGPoint)point
{
    if([self.symbol isEqualToString:@"squiggle"]) {
        [self drawSquiggleAtPoint:point];
    }
    
    if([self.symbol isEqualToString:@"diamond"]) {
        [self drawDiamondAtPoint:point];
    }
}

- (void)drawSquiggleAtPoint:(CGPoint)point
{
    NSUInteger width = self.bounds.size.width * SYMBOL_WIDTH;
    NSUInteger height = self.bounds.size.height * SYMBOL_HEIGHT;
    
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    CGFloat xl = x - (width / 2); // X LEFT
    CGFloat xlc = x - (width / 4); // X LEFT CENTER
    CGFloat xr = x + (width / 2); // X RIGHT
    CGFloat xrc = x + (width / 4); // X RIGHT CENTER
    
    CGFloat yt = y - (height / 2); // Y TOP
    CGFloat ytc = y - (height / 4); // Y TOP CENTER
    CGFloat yb = y + (height / 2); // Y BOTTOM
    CGFloat ybc = y + (height / 4); // Y BOTTOM CENTER
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint point1 = CGPointMake(xl, yb);
    CGPoint point2 = CGPointMake(xlc, yt);
    CGPoint point3 = CGPointMake(xr, yt);
    CGPoint point4 = CGPointMake(xrc, yb);

    CGPoint point1_1 = CGPointMake(xl, yt);
    CGPoint point2_1 = CGPointMake(x, yt);
    CGPoint point2_2 = CGPointMake(xrc, ybc);
    CGPoint point3_1 = CGPointMake(xr, yb);
    CGPoint point4_1 = CGPointMake(x, yb);
    CGPoint point4_2 = CGPointMake(xlc, ytc);
    
    
    [path moveToPoint:point1];
    [path addQuadCurveToPoint:point2 controlPoint:point1_1];
    [path addCurveToPoint:point3 controlPoint1:point2_1 controlPoint2:point2_2];
    [path addQuadCurveToPoint:point4 controlPoint:point3_1];
    [path addCurveToPoint:point1 controlPoint1:point4_1 controlPoint2:point4_2];
    
    [path closePath];
    
    [self fillSymbolPath:path];
    [self strokeSymbolPath:path];
}

- (void)drawDiamondAtPoint:(CGPoint)point
{
    NSUInteger width = self.bounds.size.width * SYMBOL_WIDTH;
    NSUInteger height = self.bounds.size.height * SYMBOL_HEIGHT;
    
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    CGFloat xl = x - (width / 2); // X LEFT
    CGFloat xr = x + (width / 2); // X RIGHT
    
    CGFloat yt = y - (height / 2); // Y TOP
    CGFloat yb = y + (height / 2); // Y BOTTOM
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint point1 = CGPointMake(xl, y);
    CGPoint point2 = CGPointMake(x, yt);
    CGPoint point3 = CGPointMake(xr, y);
    CGPoint point4 = CGPointMake(x, yb);
    
    
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point1];
    
    [path closePath];
    
    [self fillSymbolPath:path];
    [self strokeSymbolPath:path];
}

-(void)fillSymbolPath:(UIBezierPath *)path
{
    if ([self.shading isEqualToString:@"solid"]) {
        [[self getColor] setFill];
        [path fill];
    }
}
-(void)strokeSymbolPath:(UIBezierPath *)path
{
    [[self getColor] setStroke];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [path stroke];
}

-(UIColor *)getColor
{
    if ([self.color isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([self.color isEqualToString:@"green"]) {
        return [UIColor greenColor];
    } else if ([self.color isEqualToString:@"purple"]) {
        return [UIColor purpleColor];
    }
    
    return nil;
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
