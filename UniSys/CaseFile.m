//
//  CaseFile.m
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "CaseFile.h"
#import "Component+UniSys.h"
#import "ValveEquipment.h"
#import "PumpEquipment.h"

@implementation CaseFile

- (instancetype)init {
    self = [super init];
    if (self) {
        self.components = [[NSMutableArray alloc]init];
        self.totalSteams = [[NSMutableDictionary alloc]init];
        self.totalEquipments = [[NSMutableDictionary alloc]init];
        self.model = PR;
        self.name = @"New Project";
    }
    return self;
}

- (NSInteger)componentCount {
    return self.components.count;
}

- (void)addComponent:(Component *)comp {
    for (int i=0; i<self.componentCount; i++) {
        if ([comp isTheSame:self.components[i]]) {
            return;
        }
    }
    
    [self.components addObject:comp];
}

- (void)deleteComponent:(Component *)comp {
    [self.components removeObject:comp];
}

- (NSString *)newSteam {
    NSString *steamID = [NSString stringWithFormat:@"%lu",self.totalSteams.count+1];
    NSString *name = [NSString stringWithFormat:@"Steam %@",steamID];
    Steam *newSteam = [[Steam alloc]initWithName:name andComponents:self.components];
    [self.totalSteams setObject:newSteam forKey:steamID];
    return steamID;
}

- (NSString *)newEquipment:(EquipmentTag)tag {
    NSString *equipID = [NSString stringWithFormat:@"%lu",self.totalEquipments.count+1];
    BaseEquipment *equip;
    switch (tag) {
        case ValveTag:
            equip = [[ValveEquipment alloc]init];
            [self.totalEquipments setObject:equip forKey:equipID];
            break;
            
        default:
            equip = [[ValveEquipment alloc]init];
            [self.totalEquipments setObject:equip forKey:equipID];
            break;
    }
    
    return equipID;
}

@end
