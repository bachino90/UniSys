//
//  ValveView.m
//  UniSys
//
//  Created by Emiliano Bivachi on 05/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "ValveView.h"

@implementation ValveView

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
    UIColor *color = [UIColor colorWithRed:0.578 green:0.56 blue:0.56 alpha:1];
    
    UIBezierPath *polygonPath = [UIBezierPath bezierPath];
    [polygonPath moveToPoint:CGPointMake(36, 32.5)];
    [polygonPath addLineToPoint:CGPointMake(54.62, 68.5)];
    [polygonPath addLineToPoint:CGPointMake(17.38, 68.5)];
    [polygonPath closePath];
    [color setFill];
    [polygonPath fill];
    [color setStroke];
    polygonPath.lineWidth = 1;
    [polygonPath stroke];
    
    UIBezierPath *polygon2Path = [UIBezierPath bezierPath];
    [polygon2Path moveToPoint:CGPointMake(36, 36.5)];
    [polygon2Path addLineToPoint:CGPointMake(17.38, 0.5)];
    [polygon2Path addLineToPoint:CGPointMake(54.62, 0.5)];
    [polygon2Path closePath];
    [color setFill];
    [polygon2Path fill];
    [color setStroke];
    polygon2Path.lineWidth = 1;
    [polygon2Path stroke];

}


@end
