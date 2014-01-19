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

@property (nonatomic, readwrite) double z;

@property (nonatomic, readwrite) double idealEnthalpy;
@property (nonatomic, readwrite) double idealEntropy;

- (void)calcIntensiveProperties;

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
    if (temperature > 0 && temperature < 2000) {
        _temperature = temperature;
    }
}

- (void)setPressure:(double)pressure {
    if (pressure > 0 && pressure < 3e7) {
        _pressure = pressure;
    }
}

- (void)setVolumen:(double)volumen {
    if (volumen > 0) {
        _volumen = volumen;
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

- (double)z {
    return 1.0;
}

- (double)enthalpy {
    return self.idealEnthalpy;
}

- (double)entropy {
    return self.idealEntropy;
}

/******
 FUNCTIONS
******/

#pragma mark - Functions

- (void) checkDegreeOfFreedom {
    if (self.temperature > 0 && self.components && self.composition) {
        if (self.pressure > 0) {
            self.volumen = R_CONST * self.temperature / self.pressure; // V=RT/P
            [self calcIntensiveProperties];
        } else if (self.volumen > 0) {
            self.pressure = R_CONST * self.temperature / self.volumen; // P=RT/V
            [self calcIntensiveProperties];
        }
        
    }
}

- (void)calcIntensiveProperties {
    // calcular entalpia y entropia ideales
}

@end
