//
//  PumpView.m
//  UniSys
//
//  Created by Emiliano Bivachi on 05/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "PumpView.h"

@implementation PumpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIColor *color = [UIColor colorWithRed:0.319 green:0.311 blue:0.311 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:0.429 green:0.417 blue:0.417 alpha:1];
    
    UIBezierPath *polygonPath = [UIBezierPath bezierPath];
    [polygonPath moveToPoint:CGPointMake(42.5, 53.5)];
    [polygonPath addLineToPoint:CGPointMake(55.49, 71.5)];
    [polygonPath addLineToPoint:CGPointMake(29.51, 71.5)];
    [polygonPath closePath];
    [color2 setFill];
    [polygonPath fill];
    [color2 setStroke];
    polygonPath.lineWidth = 1;
    [polygonPath stroke];
    
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(27.5, 38.5, 30, 30)];
    [color setFill];
    [ovalPath fill];
    [color setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(22.5, 59.5, 13, 7)];
    [color setFill];
    [rectanglePath fill];
    [color setStroke];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];

    
    UIBezierPath *rectangle2Path = [UIBezierPath bezierPathWithRect:CGRectMake(41.5, 38.5, 20, 7)];
    [color setFill];
    [rectangle2Path fill];
    [color setStroke];
    rectangle2Path.lineWidth = 1;
    [rectangle2Path stroke];

}


@end
