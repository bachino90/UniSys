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

@property (nonatomic, readwrite) double enthalpy;
@property (nonatomic, readwrite) double entropy;
@property (nonatomic, readwrite) double z;

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

- (void)calculateComponentsParamsAandB {
    Component *comp;
    double k;
    for (int i=0; i<self.composition.count; i++) {
        comp = ((Component *)self.composition[i]);
        if (comp.w <= 0.49) {
            k = 0.37464 + 1.54226 * comp.w - 0.26992 * comp.w * comp.w;
        } else {
            double wcuad = comp.w * comp.w;
            k = 0.379642 + 1.48503 * comp.w - 0.164423 * wcuad + 0.016666 * wcuad * comp.w;
        }
        double alfa = 1 + k * (1-sqrt(self.temperature/comp.tc));
        comp.paramA = 0.45724 * pow((R_CONST * comp.tc), 2) * alfa / comp.pc;
        comp.paramB = 0.07780 * (R_CONST * comp.tc) / comp.pc;
    }
}

- (void)calculateConstantAandB {
    if (self.composition.count > 1) {
        Component *compI;
        Component *compJ;
        for (int i=0; i<self.composition.count; i++) {
            compI =((Component *)self.composition[i]);
            
            self.paramB += compI.composition * compI.paramB;
            
            for (int j=0; j<self.composition.count; j++) {
                compJ =((Component *)self.composition[j]);
                
                double aij = sqrt(compI.paramA * compJ.paramA);
                
                self.paramA += compI.composition * compJ.composition * aij;
                
            }
        }
    } else {
        Component *comp = ((Component *)self.composition.firstObject);
        self.paramA = comp.paramA;
        self.paramB = comp.paramB;
    }
    
    
    self.constA = self.paramA * self.pressure / (R_CONST * R_CONST * self.temperature * self.temperature);
    self.constB = self.paramB * self.pressure / (R_CONST * self.temperature);
}

- (double)cubicZ:(double)z alfa:(double)a beta:(double)b gamma:(double)g {
    double zCuad = z * z;
    return zCuad * z + a * z + b * z + g;
}

- (void)calculateWithPandT {
    [self calculateConstantAandB];
    
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
        } else if (fc == 0) {
            break;
        }
    }
    
    self.z = c;
    
    [self calculateIntensiveProperties];
}

- (void)calculateWithVandT {
    [self calculateConstantAandB];
    
}

- (void)calculateIntensiveProperties {
    double z = self.z;
    double B = self.constB;
    double A = self.constA;
    
    double lnPhi = - log(z - B) + (z - 1) - (A / (2*sqrt(2)*B)) * log((z+(sqrt(2)+1)*B)/(z-(sqrt(2)+1)*B));
    
}



@end
