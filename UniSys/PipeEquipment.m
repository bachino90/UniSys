//
//  PipeEquipment.m
//  UniSys
//
//  Created by Emiliano Bivachi on 13/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "PipeEquipment.h"
#import "RealFluid.h"

@implementation PipeEquipment

- (NSInteger)maxFlowInletStreams {
    return 1;
}

- (NSInteger)minFlowInletStreams {
    return 1;
}

- (NSInteger)maxFlowOutletStreams {
    return 1;
}

- (NSInteger)minFlowOutletStreams {
    return 1;
}

- (BOOL)checkDegreeOfFreedom {
    if (self.inletStreams || self.outletStreams) {
        return YES;
    } else {
        return NO;
    }
}

- (void)performMassEnergyBalance {
    if (![self checkDegreeOfFreedom]) {
        return ;
    }
    
    //RealFluid *inlet = self.inletStreams.firstObject;
    //RealFluid *outlet = self.outletStreams.firstObject;
}

@end
