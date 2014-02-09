//
//  EquipmentView.m
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "EquipmentView.h"
#import "SteamView.h"
#import "PumpView.h"
#import "ValveView.h"

@interface EquipmentView ()
@property (nonatomic, readwrite) NSString * equipmentID;
@end

@implementation EquipmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEquipment:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        
        self.gestureRecognizers = [self.gestureRecognizers arrayByAddingObject:tapGesture];
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

+ (EquipmentView *)viewForEquipment:(EquipmentTag)equipment andID:(NSString *)equipID {
    EquipmentView *equip = nil;
    switch (equipment) {
        case SteamTag:
            equip = [[ValveView alloc]init];
            break;
        case ValveTag:
            equip = [[ValveView alloc]init];
            break;
        default:
            equip = [[ValveView alloc]init];
            break;
    }
    equip.backgroundColor = [UIColor clearColor];
    equip.equipmentID = equipID;
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
