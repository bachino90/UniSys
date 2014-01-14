//
//  TurbineEquipment.m
//  UniSys
//
//  Created by Emiliano Bivachi on 13/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "TurbineEquipment.h"
#import "RealFluid.h"

@implementation TurbineEquipment

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

- (BOOL)isThereHeatStream {
    return NO;
}

- (BOOL)isThereWorkStream {
    return YES;
}

- (BOOL)checkDegreeOfFreedom {
    if (self.inletStreams || self.outletStreams) {
        return YES;
    } else {
        return NO;
    }
}

- (double)calculateOutletTemperature {
    double a,b,c;
    c=0;
    
    return c;
}

- (void)performMassEnergyBalance {
    if (![self checkDegreeOfFreedom]) {
        return ;
    }
    
    RealFluid *inlet = self.inletStreams.firstObject;
    RealFluid *outlet = self.outletStreams.firstObject;
    
    if (inlet.isDeterminated) {
        
        // Balance de masa
        outlet.molarFlow = inlet.molarFlow;
        
        //Balance de energia
        if (self.workStream > 0) {
            //Calcular la presion y temperatura de la corriente de salida
        } else if (outlet.pressure > 0) {
            //Calcular el trabajo necesario para alcanzar esa presion;
        }
    } else if (outlet.isDeterminated) {
        // Balance de masa
        inlet.molarFlow = outlet.molarFlow;
        
        //Balance de energia
        if (self.workStream > 0) {
            //Calcular la presion y temperatura de la corriente de salida
        } else if (inlet.pressure > 0) {
            //Calcular el trabajo necesario para alcanzar esa presion;
        }
    }
}

@end
