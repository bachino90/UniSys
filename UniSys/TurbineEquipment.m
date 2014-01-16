//
//  TurbineEquipment.m
//  UniSys
//
//  Created by Emiliano Bivachi on 13/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "TurbineEquipment.h"

@interface TurbineEquipment ()
@end

@implementation TurbineEquipment

- (RealFluid *)inletFluid {
    return ((RealFluid *)self.inletStreams.firstObject);
}

- (RealFluid *)outletFluid {
    return ((RealFluid *)self.outletStreams.firstObject);
}

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

- (double)calculateOutletReversibleTemperature {
    double inletEntropy = self.inletFluid.molarEntropy;
    FunctionBlock entropyBalance = ^(double t){
        self.outletFluid.temperature = t;
        double outletEntropy = self.outletFluid.molarEntropy;
        return outletEntropy - inletEntropy;
    };
    
    NSDictionary *resultsEntropyBalance = [[NumericHelpers sharedInstance] regulaFalsiMethod:entropyBalance infLimit:0.0 supLimit:self.inletFluid.temperature];
    
    double outletReversibleTemperature = [resultsEntropyBalance[@"ZEROS"] doubleValue];
    
    return outletReversibleTemperature;
}

- (double)calculateOutletTemperature {

    double outletReversibleTemperature = [self calculateOutletReversibleTemperature];
    
    self.outletFluid.temperature = outletReversibleTemperature;
    double outletEnthalpyReversible = self.outletFluid.molarEnthalpy;
    double inletEnthalpy = self.inletFluid.molarEnthalpy;
    double deltaReversibleEnthalpy = outletEnthalpyReversible - inletEnthalpy;
    
    FunctionBlock enthalpyPerformance = ^(double t){
        self.outletFluid.temperature = t;
        double outletEnthalpy = self.outletFluid.molarEnthalpy;
        return (outletEnthalpy - inletEnthalpy) - self.isoEntropyPerformance * deltaReversibleEnthalpy;
    };
    
    NSDictionary *resultsEnthalpyPerformance = [[NumericHelpers sharedInstance] regulaFalsiMethod:enthalpyPerformance infLimit:outletReversibleTemperature supLimit:outletReversibleTemperature + 200];
    
    double outletTemperature = [resultsEnthalpyPerformance[@"ZEROS"] doubleValue];
    
    self.outletFluid.temperature = outletTemperature;
    
    return outletTemperature;
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
