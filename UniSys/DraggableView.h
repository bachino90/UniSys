//
//  DraggableView.h
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableView : UIView {
    CGPoint lastLocation;
}

@property (nonatomic) BOOL allowedDraggableAndZoom;

@end
