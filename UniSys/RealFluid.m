//
//  RealFluid.m
//  UniSys
//
//  Created by Emiliano Bivachi on 12/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "RealFluid.h"
#import "Component.h"

@interface RealFluid ()
@property (nonatomic) double *componentKi;
@property (nonatomic, readwrite) double *liquidComposition;
@property (nonatomic, readwrite) double *gasComposition;

@property (nonatomic, strong, readwrite) RealGas *gas;
@property (nonatomic, strong, readwrite) RealGas *liquid;

@end

@implementation RealFluid

- (BOOL)isDeterminated {
    return (self.molarFlow > 0 && self.temperature > 0 && (self.pressure > 0 || self.volumen > 0) && (self.components && self.components.count>0));
}

- (double)molarEnthalpy {
    return (self.vaporRatio * self.gas.enthalpy + (1-self.vaporRatio) * self.liquid.enthalpy);
}

- (double)molarEntropy {
    return (self.vaporRatio * self.gas.entropy + (1-self.vaporRatio) * self.liquid.entropy);
}

- (double)wilsonKForComponent:(Component *)comp pressure:(double)p andTemperature:(double)t {
    return (comp.pc/p) * exp(5.373 * (1+comp.w) * (1-(comp.tc/t)));
}

- (void)calcPropertiesPT {
    if (!self.isDeterminated)
        return;
    
    double bubblePressure = [self calcBubbleP];
    double dewPressure = [self calcDewP];
    
    if (self.pressure > dewPressure && self.pressure < bubblePressure) {
        //equilibrio
        [self calcFlashPT];
    } else if (self.pressure < dewPressure) {
        //vapor sobrecalentado
        self.vaporRatio = 1;
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            self.gasComposition[i] = comp.composition;
            self.liquidComposition[i] = 0;
        }
        self.gas = [[RealGas alloc] initWithComponents:self.components isLiquid:NO];
        self.gas.temperature = self.temperature;
        self.gas.pressure = self.pressure;
        [self.gas checkDegreeOfFreedom];
        
    } else if (self.pressure > bubblePressure) {
        //liquido subenfriado
        self.vaporRatio = 0;
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            self.liquidComposition[i] = comp.composition;
            self.gasComposition[i] = 0;
        }
        self.liquid = [[RealGas alloc] initWithComponents:self.components isLiquid:YES];
        self.liquid.temperature = self.temperature;
        self.liquid.pressure = self.pressure;
        [self.liquid checkDegreeOfFreedom];
    }
}

- (void)calcPropertiesTVaporRatio {
    
}

- (void)calcPropertiesPVaporRatio {
    
}

- (void)calcPropertiesVT {
    
}

- (void)initializeComponentKi {
    free(_componentKi);
    free(_liquidComposition);
    free(_gasComposition);
    _componentKi = (double *)calloc(self.components.count,sizeof(double));
    _liquidComposition = (double *)calloc(self.components.count,sizeof(double));
    _gasComposition = (double *)calloc(self.components.count,sizeof(double));
    for (int i=0; i<self.components.count; i++) {
        Component *comp = self.components[i];
        _componentKi[i] = [self wilsonKForComponent:comp pressure:self.pressure andTemperature:self.temperature];
    }
    
}

- (BOOL)compareOldXi:(double [])xi andOldYi:(double [])yi {
    BOOL cont = NO;
    double error = 0.0001;
    for (int i=0; i<self.components.count; i++) {
        if ((ABS(xi[i] - _liquidComposition[i]) > error) || (ABS(yi[i] - _gasComposition[i]) > error)) {
            cont = YES;
            break;
        }
    }
    return cont;
}

- (void)calcFlashPT {
    if (!self.isDeterminated)
        return;
    
    [self initializeComponentKi];
    
    FunctionBlock betaFunction = ^(double beta) {
        __block double f = 0;
        double *ki = self.componentKi;
        [self.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Component *comp = (Component *)obj;
            f += (ki[idx] * comp.composition)/(1+beta*(ki[idx]-1));
        }];
        return f;
    };
    
    double xi[self.components.count];
    double yi[self.components.count];
    RealGas *gasB;
    RealGas *liquidB;
    double beta;
    
    do {
        NSDictionary *results = [[NumericHelpers sharedInstance] regulaFalsiMethod:betaFunction infLimit:0.0 supLimit:1.0];
        
        beta = [results[@"ZEROS"] doubleValue];
        
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            double *ki = self.componentKi;
            xi[i] = comp.composition / (1+beta * (ki[i]-1));
            yi[i] = ki[i] * comp.composition / (1+beta * (ki[i]-1));
        }
        
        gasB = [[RealGas alloc] initWithComponents:self.components isLiquid:NO];
        liquidB = [[RealGas alloc] initWithComponents:self.components isLiquid:YES];
        
        liquidB.temperature = self.temperature;
        liquidB.pressure = self.pressure;
        liquidB.composition = xi;
        [liquidB checkDegreeOfFreedom];
        
        gasB.temperature = self.temperature;
        gasB.pressure = self.pressure;
        gasB.composition = yi;
        [gasB checkDegreeOfFreedom];
        
        for (int i=0; i<self.components.count; i++) {
            _componentKi[i] = exp(liquidB.lnPhi - gasB.lnPhi);
        }
        
    } while ([self compareOldXi:xi andOldYi:yi]);
    
    self.liquidComposition = xi;
    self.gasComposition = yi;
    self.vaporRatio = beta;
    
    self.gas = gasB;
    self.liquid = liquidB;
}

- (double)calcDewP {
    double gasComp[self.components.count];
    for (int i=0; i<self.components.count; i++) {
        Component *comp = self.components[i];
        gasComp[i] = comp.composition;
    }
    
    [self initializeComponentKi];
    
    return 0;
}

- (double)calcBubbleP {
    double liquidComp[self.components.count];
    for (int i=0; i<self.components.count; i++) {
        Component *comp = self.components[i];
        liquidComp[i] = comp.composition;
    }
    [self initializeComponentKi];
    
    double F;
    double dFdP;
    double Pj = self.pressure;
    double Pj1 = self.pressure;
    RealGas *gasB;
    RealGas *liquidB;
    liquidB = [[RealGas alloc] initWithComponents:self.components isLiquid:YES];
    
    liquidB.temperature = self.temperature;
    liquidB.pressure = self.pressure;
    liquidB.composition = liquidComp;
    [liquidB checkDegreeOfFreedom];
    
    do {
        Pj = Pj1;
        double gasComp[self.components.count];
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            gasComp[i] = comp.composition * _componentKi[i];
        }
        
        gasB = [[RealGas alloc] initWithComponents:self.components isLiquid:NO];
        
        gasB.temperature = self.temperature;
        gasB.pressure = self.pressure;
        gasB.composition = gasComp;
        [gasB checkDegreeOfFreedom];
        
        F = -1;
        dFdP = 0;
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            _componentKi[i] = exp(liquidB.lnPhi - gasB.lnPhi);
            F += comp.composition * _componentKi[i];
        }
        
        Pj1 = Pj - F/dFdP;
    } while (ABS(Pj1-Pj)>0.1);
    
    return Pj1;
}

@end
