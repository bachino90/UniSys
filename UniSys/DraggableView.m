//
//  DraggableView.m
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "DraggableView.h"

@interface DraggableView ()
@end

@implementation DraggableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(detectPan:)];
        self.gestureRecognizers = @[panRecognizer];
        self.allowedDraggableAndZoom = YES;
    }
    return self;
}

- (void)detectPan:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint translation = [panRecognizer translationInView:self.superview];
    CGPoint newCenter = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y);
    CGFloat midPointX = CGRectGetMidX(self.bounds);
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    CGFloat scrollWidth = ((UIScrollView *)self.superview).contentSize.width;
    CGFloat scrollHeight = ((UIScrollView *)self.superview).contentSize.height;
    if (newCenter.x > scrollWidth - midPointX) {
        newCenter.x = scrollWidth - midPointX;
    }
    if (newCenter.x < midPointX) {
        newCenter.x = midPointX;
    }
    if (newCenter.y > scrollHeight - midPointY) {
        newCenter.y = scrollHeight - midPointY;
    }
    if (newCenter.y < midPointY) {
        newCenter.y = midPointY;
    }
    if (self.allowedDraggableAndZoom) {
        self.center = newCenter;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];
    
    lastLocation = self.center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
