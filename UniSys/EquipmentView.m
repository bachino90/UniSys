//
//  EquipmentView.m
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "EquipmentView.h"
#import "FlowView.h"

@implementation EquipmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEquipment:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        self.gestureRecognizers = @[tapGesture];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectMake(325.0, 450.0, 70.0, 70.0)];
}

- (void)tapEquipment:(UITapGestureRecognizer *)tapGesture {
    [self.delegate equipmentViewClicked:self];
}

+ (NSArray *)equipmentsButtonImages {
    return @[@"Flow",@"Valva",@"Valva",@"Valva",@"Valva",@"Valva",@"Valva",@"Valva",@"Valva",@"Valva",@"Valva",@"Valva",@"Valva",@"Valva"];
}

+ (EquipmentView *)viewForEquipment:(EquipmentTag)equipment {
    EquipmentView *equip = nil;
    switch (equipment) {
        case FlowTag:
            equip = [[FlowView alloc]init];
            break;
        case ValveTag:
            equip = [[FlowView alloc]init];
            break;
        default:
            equip = [[FlowView alloc]init];
            break;
    }
    equip.backgroundColor = [UIColor blueColor];
    return equip;
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
