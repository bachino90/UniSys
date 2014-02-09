//
//  IdealGas.m
//  UniSys
//
//  Created by Emiliano Bivachi on 18/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "IdealGas.h"
#import "Component.h"

@interface IdealGas ()

@property (nonatomic, readwrite) long double z;
@property (nonatomic, readwrite) double volumen;

@property (nonatomic, readwrite) double idealEnthalpy;
@property (nonatomic, readwrite) double idealEntropy;

@end

@implementation IdealGas

/******
 INITIALIZE
******/

- (instancetype)initWithComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid {
    self = [super init];
    if (self) {
        self.components = comp;
        _isLiquid = isLiquid;
        _composition = (double *)calloc(self.components.count, sizeof(double));
        for (int i=0; i<self.components.count; i++) {
            _composition[i] = ((Component *)self.components[i]).composition;
        }
    }
    return self;
}

- (instancetype)initWithComponents:(NSArray *)comp {
    return [self initWithComponents:comp isLiquid:NO];
}

/******
PROPERTIES SETTERS
******/

#pragma mark - Setters

- (void)setTemperature:(double)temperature {
    if (temperature > 0) {
        _temperature = temperature;
    }
}

- (void)setPressure:(double)pressure {
    if (pressure > 0) {
        _pressure = pressure;
    }
}

- (void)setComposition:(double *)composition {
    _composition = composition;
    for (int i=0; i<self.components.count; i++) {
        Component *comp = self.components[i];
        comp.composition = composition[i];
    }
}

/******
 PROPERTIES GETTERS
******/

#pragma mark - Getters

- (long double)z {
    return 1.0L;
}

- (double)enthalpy {
    return self.idealEnthalpy;
}

- (double)entropy {
    return self.idealEntropy;
}

- (double)isothermalCompressibility {
    return 1/self.pressure;
}

/******
 FUNCTIONS
******/

#pragma mark - Functions

- (void)checkDegreeOfFreedom {
    if (self.temperature > 0 && self.components && self.composition) {
        if (self.pressure > 0) {
            self.volumen = R_CONST * self.temperature / self.pressure; // V=RT/P
        } else if (self.volumen > 0) {
            self.pressure = R_CONST * self.temperature / self.volumen; // P=RT/V
        }
        
    }
}

- (void)calcIdealProperties {
    // calcular entalpia y entropia ideales
    // c* cotnh(c/x) = c*(1/tnh(c/x)))  //esta es la del sinh
    // -c*tnh(c/x)  //esta es la del cosh
    
    double C1 = 0.0;
    double C2 = 0.0;
    double C3 = 0.0;
    double C4 = 0.0;
    double C5 = 0.0;
    
    double t = self.temperature;
    //double p = self.pressure;
    
    self.idealEnthalpy = C1 * (t-T0) + C2 * C3 * ((1/tanh(C3/t)) - (1/tanh(C3/T0))) + C4 * C5 * (tanh(C5/T0) - tanh(C5/t));
    self.idealEntropy = 0.0;
}

@end
