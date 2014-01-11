//
//  RealGas.m
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "RealGas.h"
#import "Component.h"


#define R_CONST 8.314472


@interface RealGas ()

- (void)checkDegreeOfFreedom;

@property (nonatomic) double z;

@property (nonatomic) double constA;
@property (nonatomic) double constB;

@property (nonatomic) double paramA;
@property (nonatomic) double paramB;

@end

@implementation RealGas

- (instancetype)initWithComponents:(NSArray *)comp {
    self = [super init];
    if (self) {
        self.composition = comp;
    }
    return self;
}


- (void) checkDegreeOfFreedom {
    if (self.temperature > 0) {
        if (self.pressure > 0) {
            [self calculateWithPandT];
        } else if (self.volumen > 0) {
            [self calculateWithVandT];
        }
    }
}

- (void)setTemperature:(double)temperature {
    if (temperature > 0 && temperature < 2000) {
        _temperature = temperature;
        [self checkDegreeOfFreedom];
    }
}

- (void)setPressure:(double)pressure {
    if (pressure > 0 && pressure < 3e7) {
        _pressure = pressure;
        [self checkDegreeOfFreedom];
    }
}

- (void)setVolumen:(double)volumen {
    if (volumen > 0) {
        _volumen = volumen;
        [self checkDegreeOfFreedom];
    }
}

- (void)calculateAandB {
    for (int i=0; i<self.composition.count; i++) {
        Component *compI =((Component *)self.composition[i]);
        for (int j=0; j<self.composition.count; j++) {
            
        }
    }
    
    self.constA = self.paramA * self.pressure / (R_CONST * R_CONST * self.temperature * self.temperature);
    self.constB = self.paramB * self.pressure / (R_CONST * self.temperature);
}

- (double)cubicZ:(double)z alfa:(double)a beta:(double)b gamma:(double)g {
    double zCuad = z * z;
    return zCuad * z + a * z + b * z + g;
}

- (void)calculateWithPandT {
    [self calculateAandB];
    
    double Bcuad = self.constB;
    double alfa = - 1 + self.constB;
    double beta = self.constA - 3 * Bcuad - 2 * self.constB;
    double gamma = - self.constA * self.constB + Bcuad + Bcuad * self.constB;
    
    double error = 0.001;
    double a = 0.5;
    double b = 1.5;
    
    double c;
    double fa;
    double fb;
    double fc;
    
    while (ABS(fc) > error) {
        fa = [self cubicZ:a alfa:alfa beta:beta gamma:gamma];
        fb = [self cubicZ:b alfa:alfa beta:beta gamma:gamma];
        c = b - (fb * (b - a)/(fb - fa));
        fc = [self cubicZ:c alfa:alfa beta:beta gamma:gamma];
        if (fa * fc < 0) {
            b = c;
        } else if (fb * fc < 0) {
            a = c;
        }
    }
    
    self.z = c;
}

- (void)calculateWithVandT {
    [self calculateAandB];
    
}



@end
