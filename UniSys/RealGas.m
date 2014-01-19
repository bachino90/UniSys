//
//  RealGas.m
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "RealGas.h"
#import "Component.h"

@interface RealGas ()

@property (nonatomic, readwrite) double z;
@property (nonatomic, readwrite) double enthalpy;
@property (nonatomic, readwrite) double entropy;
@property (nonatomic, readwrite) double lnPhi;
@property (nonatomic, readwrite) double *componentLnPhi;

@property (nonatomic) double constA;
@property (nonatomic) double constB;

@property (nonatomic) double paramA;
@property (nonatomic) double paramB;

@property (nonatomic) double dadt;
@property (nonatomic) double dzdt;
@property (nonatomic) double dzdp;

@property (nonatomic) BOOL isLiquid;

@end

@implementation RealGas

- (instancetype)initWithComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid {
    self = [super init];
    if (self) {
        self.components = comp;
        self.isLiquid = isLiquid;
        _componentLnPhi = (double *)calloc(self.components.count, sizeof(double));
    }
    return self;
}

- (instancetype)initWithComponents:(NSArray *)comp {
    return [self initWithComponents:comp isLiquid:NO];
}


- (void) checkDegreeOfFreedom {
    if (self.temperature > 0 && self.components && self.composition) {
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

- (void)calculateComponentsParamsAandB {
    Component *comp;
    double k;
    for (int i=0; i<self.components.count; i++) {
        comp = ((Component *)self.components[i]);
        if (comp.w <= 0.49) {
            k = 0.37464 + 1.54226 * comp.w - 0.26992 * comp.w * comp.w;
        } else {
            double wcuad = comp.w * comp.w;
            k = 0.379642 + 1.48503 * comp.w - 0.164423 * wcuad + 0.016666 * wcuad * comp.w;
        }
        double alfa = 1 + k * (1-sqrt(self.temperature/comp.tc));
        comp.cubic_a = 0.45724 * pow((R_CONST * comp.tc), 2) * alfa / comp.pc;
    }
}

- (void)calculateConstantAandB {
    Component *compI = 0;
    Component *compJ = 0;
    self.paramA = 0;
    self.paramB = 0;
    for (int i=0; i<self.components.count; i++) {
        compI =((Component *)self.components[i]);
        self.paramB += compI.composition * compI.cubic_b;
        for (int j=0; j<self.components.count; j++) {
            compJ =((Component *)self.components[j]);
            double aij = sqrt(compI.cubic_a * compJ.cubic_a);
            self.paramA += compI.composition * compJ.composition * aij;
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
    [self calculateConstantAandB];
    
    double Bcuad = self.constB;
    double alfa = - 1 + self.constB;
    double beta = self.constA - 3 * Bcuad - 2 * self.constB;
    double gamma = - self.constA * self.constB + Bcuad + Bcuad * self.constB;

    
    FunctionBlock zFunction = ^(double z){
        double zCuad = z * z;
        return zCuad * z + alfa * z + beta * z + gamma;
    };
    
    NSDictionary *results = [[NumericHelpers sharedInstance] regulaFalsiMethod:zFunction infLimit:0.5 supLimit:1.5];
    self.z = [results[@"ZEROS"] doubleValue];
    
    [self calculateIntensiveProperties];
}

- (void)calculateWithVandT {
    [self calculateConstantAandB];
    
    double vol = self.volumen;
    double t = self.temperature;
    double a = self.paramA;
    double b = self.paramB;
    
    _pressure = ((R_CONST * t)/(vol - b)) - (a/(vol * (vol + b) + b * (vol - b)));
    
    [self calculateIntensiveProperties];
}

- (void)calculateIntensiveProperties {
    double z = self.z;
    double B = self.constB;
    double A = self.constA;
    Component *comp;
    self.lnPhi = 0;
    for (int i = 0; i<self.components.count; i++) {
        comp = ((Component *)self.components[i]);
        double AB = 0;
        for (int j = 0; j<self.components.count; j++) {
            Component *compJ = ((Component *)self.components[j]);
            double aij = sqrt(compJ.cubic_a * comp.cubic_a);
            AB += compJ.composition * aij;
        }
        AB *= 2/self.paramA;
        AB -= (comp.cubic_b / self.paramB);
        double lnPhi = - log(z - B) + (z - 1) * (comp.cubic_b / self.paramB) - (A / (2*sqrt(2)*B)) * AB * log((z+(sqrt(2)+1)*B)/(z-(sqrt(2)-1)*B));
        
        _componentLnPhi[i] = lnPhi;
        self.lnPhi += comp.composition * lnPhi;
    }
    
    self.entropy = R_CONST * log(z-B) + (self.dadt / (2*sqrt(2)*self.paramB)) * log((z+(sqrt(2)+1)*B)/(z+(-sqrt(2)+1)*B));
    self.enthalpy = R_CONST * self.temperature * (z-1) + (((self.temperature * self.dadt)-self.paramA) / (2*sqrt(2)*self.paramB)) * log((z+(sqrt(2)+1)*B)/(z+(-sqrt(2)+1)*B));
}


- (double *)derivateLnPhiInPressure {
    double z = self.z;
    double B = self.constB;
    double A = self.constA;
    double p =self.pressure;
    Component *comp;
    
    double *DlnPhiDP;
    DlnPhiDP = (double *)calloc(self.components.count, sizeof(double));
    double dzdp = (B * (2*A+2*B*z+z) - A*z)/(p*(3*z*z-2*z+A-B-B*B));
    
    for (int i = 0; i<self.components.count; i++) {
        comp = ((Component *)self.components[i]);
        DlnPhiDP[i] = (comp.cubic_b * dzdp / self.paramB) + ((dzdp - (B/p))/(B-z))+((A/(z+B))*(1 - (comp.cubic_b/self.paramB))*((dzdp/z)-(1/p)));
    }
    return DlnPhiDP;
}

- (double *)derivateLnPhiInTemperature {
    double z = self.z;
    double B = self.constB;
    double A = self.constA;
    double t = self.temperature;
    Component *comp;
    
    double *DlnPhiDP;
    DlnPhiDP = (double *)calloc(self.components.count, sizeof(double));
    double dAdt = A * ((self.dadt/self.paramA)-(2/t));
    double dzdt = (dAdt*(B-z)-B*(A+z+2*B*z)*t)/(3*z*z-2*z+A-B-B*B);
    
    for (int i = 0; i<self.components.count; i++) {
        comp = ((Component *)self.components[i]);
        //DlnPhiDP[i] = (comp.paramB * dzdp / self.paramB) + ((dzdp - (B/p))/(B-z))+((A/(z+B))*(1 - (comp.paramB/self.paramB))*((dzdp/z)-(1/p)));
    }
    return DlnPhiDP;
}


@end
