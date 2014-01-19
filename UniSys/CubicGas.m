//
//  CubicGas.m
//  UniSys
//
//  Created by Emiliano Bivachi on 18/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "CubicGas.h"
#import "Component.h"

@interface CubicGas ()

@property (nonatomic, readwrite) CubicEOS type;
@property (nonatomic, readwrite) NSString *eosName;

@property (nonatomic, readwrite) double z;

@property (nonatomic, readwrite) double enthalpy;
@property (nonatomic, readwrite) double entropy;

// CUBIC PARAMETERS
@property (nonatomic) double c_A;
@property (nonatomic) double c_B;

@property (nonatomic) double c_a;
@property (nonatomic) double c_b;

@property (nonatomic) double c_alpha;
@property (nonatomic) double c_beta;
@property (nonatomic) double c_gamma;

@property (nonatomic) double c_dadt;
@property (nonatomic) double c_dzdt;
@property (nonatomic) double c_dzdp;

- (void)calcIntensiveProperties;

@end

@implementation CubicGas

/******
 INITIALIZE
 ******/

- (instancetype)initWithType:(CubicEOS)type andComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid {
    self = [super initWithComponents:comp isLiquid:isLiquid];
    if (self) {
        self.type = type;
        [self calcComponentCubicParameters];
    }
    return self;
}

- (instancetype)initWithType:(CubicEOS)type andComponents:(NSArray *)comp {
    return [self initWithType:type andComponents:comp isLiquid:NO];
}

/******
 PROPERTIES SETTERS
 ******/

#pragma mark - Setters

/******
 PROPERTIES GETTERS
 ******/

#pragma mark - Getters

- (double)z {
    return _z;
}

- (double)enthalpy {
    return _enthalpy;
}

- (double)entropy {
    return _entropy;
}

- (NSString *)eosName {
    NSString *name;
    
    switch (self.type) {
        case PengRobinsonEOS:
            name = @"Peng Robinson";
            break;
        case VanDerWaalsEOS:
            name = @"van der Waals";
            break;
        case WilsonEOS:
            name = @"Wilson";
            break;
        case RedlichKwongEOS:
            name = @"Redlich Kwong";
            break;
        case SoaveEOS:
            name = @"Soave";
            break;
        case PenelouxEOS:
            name = @"Peneloux";
            break;
        case PatelTejaEOS:
            name = @"Patel and Teja";
            break;
        case StryjekVeraEOS:
            name = @"Stryjek and Vera";
            break;
            
        default:
            break;
    }
    
    return name;
}

/******
 FUNCTIONS
 ******/

#pragma mark - Functions

- (void)calcComponentCubicParameters {
    [self.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Component *comp = (Component *)obj;
        comp.cubic_b = 0.0778 * R_CONST * comp.tc / comp.pc;
        comp.cubic_a_const = 0.45724 * pow(R_CONST * comp.tc, 2) / comp.pc;
        double w = comp.w;
        switch (self.type) {
            case PengRobinsonEOS:
                comp.cubic_k = (0.37464 + 1.54226 * w - 0.2699 *w*w);
                break;
            case VanDerWaalsEOS:
                comp.cubic_k = 1;
                break;
            case WilsonEOS:
                comp.cubic_k = 1.57 + 1.62*w;
                break;
            case RedlichKwongEOS:
                comp.cubic_k = 0;
                break;
            case SoaveEOS:
                comp.cubic_k = 0.4998 + 1.5928 * w - 0.19563 *w*w + 0.025 *w*w*w;
                break;
            case PenelouxEOS:
                comp.cubic_k = 0.48 + 1.574 * w - 0.176 *w*w;
                break;
            case PatelTejaEOS:
                comp.cubic_k = 0.452413 + 1.38092 * w - 0.295937 *w*w;
                break;
            case StryjekVeraEOS:
                comp.cubic_k = 0.378893 + 1.4897153 *w - 0.17131848 *w*w + 0.0196554 *w*w*w;
                break;
            default:
                break;
        }
    }];
}

- (void)calcParameter_a_atTemperature:(double)temperature {
    [self.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Component *comp = (Component *)obj;
        double k = comp.cubic_k;
        double tr = temperature / comp.tc;
        switch (self.type) {
            case VanDerWaalsEOS:
                comp.cubic_a = comp.cubic_a_const;
                comp.cubic_dadt = 0;
                break;
            case WilsonEOS:
                comp.cubic_a = comp.cubic_a_const * (1+k*((1/tr)-1)) * tr;
                #warning Falta dadt de Wilson
                break;
            case RedlichKwongEOS:
                comp.cubic_a = comp.cubic_a_const / sqrt(tr);
                comp.cubic_dadt = comp.cubic_a_const * (-0.5 * pow(tr, -1.5)/comp.tc);
                break;
            case StryjekVeraEOS:
                #warning falta Stryjek And Vera
                break;
            default:
                comp.cubic_a = comp.cubic_a_const * pow(1+k*(1-sqrt(tr)), 2);
                comp.cubic_dadt = comp.cubic_a_const * 2 * (1+k*(1-sqrt(tr))) * (-k*0.5*pow(tr, -0.5)/comp.tc);
                break;
        }
    }];
}

- (void)calcCubicConstant {
    Component *compI;
    Component *compJ;
    self.c_a = 0;
    self.c_b = 0;
    
    [self calcParameter_a_atTemperature:self.temperature];
    for (int i=0; i<self.components.count; i++) {
        compI =((Component *)self.components[i]);
        self.c_b += compI.composition * compI.cubic_b;
        for (int j=0; j<self.components.count; j++) {
            compJ =((Component *)self.components[j]);
            #warning Falta el parametro de interaccion kij
            double aij = sqrt(compI.cubic_a * compJ.cubic_a);
            self.c_a += compI.composition * compJ.composition * aij;

            double daij = 0.5 * pow(compI.cubic_a * compJ.cubic_a, -0.5) * (compI.cubic_a * compI.cubic_dadt + compJ.cubic_a * compJ.cubic_dadt);
            self.c_dadt += compI.composition * compJ.composition * daij;
        }
    }
    
    self.c_A = self.c_a * self.pressure / pow(R_CONST * self.temperature, 2);
    self.c_B = self.c_b * self.pressure / (R_CONST * self.temperature);
}

- (void)calcAlphaBetaGamma {
    double Bcuad = self.c_B * self.c_B;
    self.c_alpha = - 1 + self.c_B;
    self.c_beta = self.c_A - 3 * Bcuad - 2 * self.c_B;
    self.c_gamma = - self.c_A * self.c_B + Bcuad + Bcuad * self.c_B;
}

- (void)checkDegreeOfFreedom {
    [super checkDegreeOfFreedom];
    
    if (self.temperature > 0 && self.components && self.composition) {
        if (self.pressure > 0) {
            [self calcZ_PT];
        } else if (self.volumen > 0) {
            [self calcZ_VT];
        }
    }
}

- (void)calcZ_PT {
    [self calcCubicConstant];

    [self calcAlphaBetaGamma];
    FunctionBlock zFunction = ^(double z){
        double zCuad = z * z;
        return zCuad * z + self.c_alpha * z + self.c_beta * z + self.c_gamma;
    };
    
    NSDictionary *results = [[NumericHelpers sharedInstance] regulaFalsiMethod:zFunction infLimit:0.5 supLimit:1.5];
    
    self.z = [results[@"ZEROS"] doubleValue];
    self.volumen = self.z * R_CONST * self.temperature / self.pressure;
    
    [self calcIntensiveProperties];
}

- (void)calcZ_VT {
    [self calcCubicConstant];
    
    #warning Falta la presion
    //self.pressure =
    
    self.z = self.pressure * self.volumen / (R_CONST * self.temperature);
    
    [self calcIntensiveProperties];
}

- (void)calcIntensiveProperties {
    
    double z = self.z;
    double p = self.pressure;
    double t = self.temperature;
    double B = self.c_B;
    double A = self.c_A;
    Component *comp;
    //self.lnPhi = 0;
    for (int i = 0; i<self.components.count; i++) {
        comp = ((Component *)self.components[i]);
        double AB = 0;
        for (int j = 0; j<self.components.count; j++) {
            Component *compJ = ((Component *)self.components[j]);
            double aij = sqrt(compJ.cubic_a * comp.cubic_a);
            AB += compJ.composition * aij;
        }
        AB *= 2/self.c_a;
        AB -= (comp.cubic_b / self.c_b);
        double lnPhi = - log(z - B) + (z - 1) * (comp.cubic_b / self.c_b) - (A / (2*sqrt(2)*B)) * AB * log((z+(sqrt(2)+1)*B)/(z-(sqrt(2)-1)*B));
        
        //_componentLnPhi[i] = lnPhi;
        //self.lnPhi += comp.composition * lnPhi;
    }
    
    self.c_dzdp = (B * (2*A+2*B*z+z) - A*z)/(p*(3*z*z-2*z+A-B-B*B));
    double dAdt = A * ((self.c_dadt/self.c_a)-(2/t));
    self.c_dzdt = (dAdt*(B-z)-B*(A+z+2*B*z)*t)/(3*z*z-2*z+A-B-B*B);
    
    double residualEntropy = R_CONST * log(z-B) + (self.c_dadt / (2*sqrt(2)*self.c_b)) * log((z+(sqrt(2)+1)*B)/(z+(-sqrt(2)+1)*B));
    double residualEnthalpy = R_CONST * self.temperature * (z-1) + (((self.temperature * self.c_dadt)-self.c_a) / (2*sqrt(2)*self.c_b)) * log((z+(sqrt(2)+1)*B)/(z+(-sqrt(2)+1)*B));
    
    self.enthalpy = residualEnthalpy + self.idealEnthalpy;
    self.entropy = residualEntropy + self.idealEntropy;
}


@end
