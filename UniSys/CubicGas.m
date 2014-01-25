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

@property (nonatomic, readwrite) FluidModelType type;
@property (nonatomic, readwrite) NSString *eosName;

@property (nonatomic, readwrite) double z;
@property (nonatomic, readwrite) double volumen;

@property (nonatomic, readwrite) double *componentLnPhi;

// CUBIC PARAMETERS
@property (nonatomic) double c_A;
@property (nonatomic) double c_B;

@property (nonatomic) double c_a;
@property (nonatomic) double c_b;
@property (nonatomic) double c_c;
@property (nonatomic) double c_delta;
@property (nonatomic) double c_epsilon;

@property (nonatomic) double c_sigma_1;
@property (nonatomic) double c_sigma_2;

@property (nonatomic) double **c_kij;

@property (nonatomic) double c_alpha;
@property (nonatomic) double c_beta;
@property (nonatomic) double c_gamma;

@property (nonatomic) double c_dadt;
@property (nonatomic) double c_dzdt;
@property (nonatomic) double c_dzdp;
@property (nonatomic, readwrite) double *DLnPhiDP;
@property (nonatomic, readwrite) double *DLnPhiDT;

- (void)calcIntensiveProperties;

@end

@implementation CubicGas

/******
 INITIALIZE
 ******/

- (instancetype)initWithType:(FluidModelType)type andComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid {
    self = [super initWithComponents:comp isLiquid:isLiquid];
    if (self) {
        self.type = type;
        [self calcBinaryParameters];
        [self calcComponentCubicParameters];
    }
    return self;
}

- (instancetype)initWithType:(FluidModelType)type andComponents:(NSArray *)comp {
    return [self initWithType:type andComponents:comp isLiquid:NO];
}

- (instancetype)initWithComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid {
    return [self initWithType:PR andComponents:comp isLiquid:isLiquid];
}

- (instancetype)initWithComponents:(NSArray *)comp {
    return [self initWithType:PR andComponents:comp isLiquid:NO];
}

/******
 PROPERTIES SETTERS
 ******/

#pragma mark - Setters

- (void)setBinaryParameters:(double **)kij {
    
}

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

/******
 FUNCTIONS
 ******/

#pragma mark - Functions

- (void)calcBinaryParameters {
    _c_kij = (double **)calloc(self.components.count, sizeof(double));
    for (int i=0; i<self.components.count; i++) {
        _c_kij[i] = (double *)calloc(self.components.count, sizeof(double));
    }
    Component *compI;
    Component *compJ;
    for (int i=0; i<self.components.count; i++) {
        compI =((Component *)self.components[i]);
        for (int j=0; j<self.components.count; j++) {
            compJ =((Component *)self.components[j]);
            if (i!=j) {
                double exp = 0.3333333;
                double vci13 = pow(compI.vc, exp);
                double vcj13 = pow(compJ.vc, exp);
                _c_kij[i][j] = 1 - (2*sqrt(vci13*vcj13)/(vci13+vcj13));
            }
            //NSLog(@"[%i][%i]:%g",i,j,_c_kij[i][j]);
        }
    }
}

- (void)calcComponentCubicParameters {
    for (int idx=0; idx<self.components.count; idx++) {
        Component *comp = (Component *)self.components[idx];
        double w = comp.w;
        comp.zra = 0.29056 - 0.08775 * w;
        switch (self.type) {
            case PR:
                comp.cubic_k = (0.37464 + 1.54226 * w - 0.2699 *w*w);
                if (w>0.49)
                    comp.cubic_k = 0.379642 + (1.48503-(0.164423-1.016666*w)*w)*w;
                comp.cubic_b = 0.077796 * R_CONST * comp.tc / comp.pc;
                comp.cubic_a_const = 0.457236 * pow(R_CONST * comp.tc, 2) / comp.pc;
                comp.cubic_c_const = 0.50033 * (0.25969 - comp.zra) * R_CONST * comp.tc / comp.pc;
                break;
            case RK:
                comp.cubic_k = 0;
                comp.cubic_b = 0.08664 * R_CONST * comp.tc / comp.pc;
                comp.cubic_a_const = 0.42748 * pow(R_CONST * comp.tc, 2) / comp.pc;
                comp.cubic_c_const = 0.40768 * (0.29441 - comp.zra) * R_CONST * comp.tc / comp.pc;
                break;
            case SRK:
            case SRKKabadiDanner:
                comp.cubic_k = 0.4998 + 1.5928 * w - 0.19563 *w*w + 0.025 *w*w*w;
                comp.cubic_b = 0.08664 * R_CONST * comp.tc / comp.pc;
                comp.cubic_a_const = 0.42748 * pow(R_CONST * comp.tc, 2) / comp.pc;
                comp.cubic_c_const = 0.40768 * (0.29441 - comp.zra) * R_CONST * comp.tc / comp.pc;
                break;
            case PRSV:
                comp.cubic_k = 0.378893 + 1.4897153 * w - 0.17131848 *w*w + 0.0196554 *w*w*w;
                comp.cubic_b = 0.07796 * R_CONST * comp.tc / comp.pc;
                comp.cubic_a_const = 0.45724 * pow(R_CONST * comp.tc, 2) / comp.pc;
                comp.cubic_c_const = 0.50033 * (0.25969 - comp.zra) * R_CONST * comp.tc / comp.pc;
                break;
            case PRTwu:
                comp.cubic_k = 1;
                comp.cubic_b = 0.077796 * R_CONST * comp.tc / comp.pc;
                comp.cubic_a_const = 0.457236 * pow(R_CONST * comp.tc, 2) / comp.pc;
                comp.cubic_c_const = 0.50033 * (0.25969 - comp.zra) * R_CONST * comp.tc / comp.pc;
            case SRKTwu:
                comp.cubic_k = 1;
                comp.cubic_b = 0.077796 * R_CONST * comp.tc / comp.pc;
                comp.cubic_a_const = 0.457236 * pow(R_CONST * comp.tc, 2) / comp.pc;
                comp.cubic_c_const = 0.40768 * (0.29441 - comp.zra) * R_CONST * comp.tc / comp.pc;
                break;
            default:
                break;
        }
    }
}

- (void)calcParameter_a_c_atTemperature:(double)temperature {
    for (int idx=0; idx<self.components.count; idx++) {
        Component *comp = (Component *)self.components[idx];
        comp.cubic_c = comp.cubic_c_const;
        double k = comp.cubic_k;
        double tr = temperature / comp.tc;
        double k_i;
        switch (self.type) {
            case RK:
                comp.cubic_a = comp.cubic_a_const / sqrt(tr);
                comp.cubic_dadt = comp.cubic_a_const * (-0.5 * pow(tr, -1.5)/comp.tc);
                break;
            case PRSV:
                k_i = k + comp.cubic_PRSV_ki * (1+pow(tr, 0.5))*(0.7-tr);
                comp.cubic_a = comp.cubic_a_const * pow(1+k_i*(1-sqrt(tr)),2);
                comp.cubic_dadt = comp.cubic_a_const * 2 * (1+k*(1-sqrt(tr)) + comp.cubic_PRSV_ki*(1-tr)*(0.7-tr)) * ((-k*0.5*pow(tr, -0.5)/comp.tc));
                break;
            case PRTwu:
            case SRKTwu:
                
                break;
            default:
                comp.cubic_a = comp.cubic_a_const * pow(1+k*(1-sqrt(tr)), 2);
                comp.cubic_dadt = comp.cubic_a_const * 2 * (1+k*(1-sqrt(tr))) * (-k*0.5*pow(tr, -0.5)/comp.tc);
                break;
        }
    }
}

- (void)calcCubicConstant {
    Component *compI;
    Component *compJ;
    self.c_a = 0;
    self.c_b = 0;
    self.c_c = 0;
    
    [self calcParameter_a_c_atTemperature:self.temperature];
    for (int i=0; i<self.components.count; i++) {
        compI =((Component *)self.components[i]);
        self.c_b += compI.composition * compI.cubic_b;
        self.c_c += compI.composition * compI.cubic_c;
        for (int j=0; j<self.components.count; j++) {
            compJ =((Component *)self.components[j]);
            double aij = sqrt(compI.cubic_a * compJ.cubic_a) * (1-_c_kij[i][j]);
            self.c_a += compI.composition * compJ.composition * aij;

            double daij = 0.5 * (1-_c_kij[i][j]) * pow(compI.cubic_a * compJ.cubic_a, -0.5) * (compI.cubic_a * compI.cubic_dadt + compJ.cubic_a * compJ.cubic_dadt);
            self.c_dadt += compI.composition * compJ.composition * daij;
        }
    }
    
    self.c_A = self.c_a * self.pressure / pow(R_CONST * self.temperature, 2);
    self.c_B = self.c_b * self.pressure / (R_CONST * self.temperature);
    
    switch (self.type) {
        case RK:
        case SRK:
        case SRKTwu:
        case SRKKabadiDanner:
            self.c_delta = self.c_b;
            self.c_epsilon = 0;
            self.c_sigma_1 = 1;
            self.c_sigma_2 = 0;
            break;
        default:
            self.c_delta = 2*self.c_b;
            self.c_epsilon = -pow(self.c_b, 2);
            self.c_sigma_1 = 1+sqrt(2);
            self.c_sigma_2 = 1-sqrt(2);
            break;
    }
}

- (void)calcAlphaBetaGamma {
    double Epsilon = self.c_epsilon * pow(self.pressure / R_CONST * self.temperature, 2);
    double Delta = self.c_delta * self.pressure / (R_CONST * self.temperature);
    self.c_alpha = - 1 - self.c_B + Delta;
    self.c_beta = self.c_A + Epsilon - Delta * (self.c_B+1);
    self.c_gamma = - self.c_A * self.c_B - Epsilon * (self.c_B+1);
    
    switch (self.type) {
        case RK:
        case SRK:
        case SRKTwu:
        case SRKKabadiDanner:
            self.c_alpha = -1;
            self.c_beta = self.c_A - self.c_B - pow(self.c_B, 2);
            self.c_gamma = - self.c_A * self.c_B;
            break;
        default:
            self.c_alpha = -1 + self.c_B;
            self.c_beta = self.c_A - 2*self.c_B - 3*pow(self.c_B, 2);
            self.c_gamma = - self.c_A * self.c_B + pow(self.c_B, 2) + pow(self.c_B, 3);
            break;
    }
}

- (void)checkDegreeOfFreedom {
    if (self.temperature > 0 && self.components && self.composition) {
        if (self.pressure > 0) {
            [self calcZ_PT];
        } else if (self.volumen > 0) {
            [self calcZ_VT];
        }
    }
}

#pragma mark - Calc PVT

- (NSDictionary *)calcZ_PT {
    [self calcCubicConstant];

    [self calcAlphaBetaGamma];
    /*
    FunctionBlock zFunction = ^(double z){
        double zCuad = z * z;
        return zCuad * z + self.c_alpha * z + self.c_beta * z + self.c_gamma;
    };
    */
    double a = 1;
    double b = self.c_alpha;
    double c = self.c_beta;
    double d = self.c_gamma;
    
    double disc = 18*a*b*c*d - 4*pow(b, 3)*d + pow(b*c, 2) - 4*a*pow(c, 3) - 27*pow(a*d, 2);
    NSLog(@"Discriminante: %g",disc);
    
    NSDictionary *results;
    if (_isLiquid) {
        FunctionBlock zLiqFunction = ^(double z){
            return self.c_B+(z+self.c_sigma_2*self.c_B)*(z+self.c_sigma_1*self.c_B)*((1+self.c_B-z)/(self.c_A));
        };
        //results = [[NumericHelpers sharedInstance] regulaFalsiMethod:zFunction infLimit:0.0 supLimit:0.5];
        results = [[NumericHelpers sharedInstance] puntoFijoMethod:zLiqFunction initValue:self.c_B infLimit:0.0 supLimit:1.0];
    } else {
        FunctionBlock zGasFunction = ^(double z){
            return 1 + self.c_B - self.c_A*(z-self.c_B)/((z+self.c_sigma_2*self.c_B)*(z+self.c_sigma_1*self.c_B));
        };
        //results = [[NumericHelpers sharedInstance] regulaFalsiMethod:zFunction infLimit:0.5 supLimit:1.5];
        results = [[NumericHelpers sharedInstance] puntoFijoMethod:zGasFunction initValue:1.0 infLimit:0.0 supLimit:3.0];
    }
    
    BOOL hayZero = [results[@"Hay zero?"] boolValue];
    if (hayZero) {
        self.z = [results[@"ZEROS"] doubleValue];
        self.volumen = self.z * R_CONST * self.temperature / self.pressure;
        if (_isLiquid) {
            self.volumen = self.volumen - self.c_c;
            self.z = self.pressure * self.volumen / (R_CONST * self.temperature);
        }
        [self calcIntensiveProperties];
    }
    
    return results;
}

- (void)calcZ_VT {
    [self calcCubicConstant];
    
    double v = self.volumen;
    self.pressure = ((R_CONST * self.temperature) / (v - self.c_b)) - (self.c_a / (v*v + self.c_delta*v + self.c_epsilon));
    
    self.z = self.pressure * self.volumen / (R_CONST * self.temperature);
    
    [self calcIntensiveProperties];
}

#pragma mark - Calc lnPhi/Enthalpy/Entropy

- (void)calcIntensiveProperties {
    
    [super calcIdealProperties];
    
    double z = self.z;
    double t = self.temperature;
    double v = self.volumen;
    double B = self.c_B;
    double A = self.c_A;
    double delta = self.c_delta;
    double epsilon = self.c_epsilon;
    double d24e05 = pow((delta*delta)-4*epsilon, 0.5);
    double ln = log((2*v + delta + d24e05)/(2*v + delta - d24e05));
    
    free(_componentLnPhi);
    _componentLnPhi = (double *)calloc(self.components.count, sizeof(double));
    
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
        double lnPhi;
        switch (self.type) {
            case RK:
            case SRK:
            case SRKTwu:
            case SRKKabadiDanner:
                lnPhi = - log(z - B) + (z - 1) * (comp.cubic_b / self.c_b) - (A / B) * AB * log(1+B/z);
                break;
            default:
                lnPhi = - log(z - B) + (z - 1) * (comp.cubic_b / self.c_b) - (A / (2*sqrt(2)*B)) * AB * ln;
                break;
        }        
        _componentLnPhi[i] = lnPhi;
    }
    
    [self derivateLnPhiInPressureAndTemperature];
    
    double residualEnthalpy = R_CONST * t * (z-1) + (((t * self.c_dadt)-self.c_a) / d24e05) * ln;
    double residualEntropy = R_CONST * log(z-B) + (self.c_dadt / d24e05) * ln;
    
    _enthalpy = residualEnthalpy + self.idealEnthalpy;
    _entropy = residualEntropy + self.idealEntropy;
}

- (void)derivateLnPhiInPressureAndTemperature {
    double z = self.z;
    double B = self.c_B;
    double A = self.c_A;
    double p = self.pressure;
    double t = self.temperature;
    
    self.c_dzdp = (B * (2*A+2*B*z+z) - A*z)/(p*(3*z*z-2*z+A-B-B*B));
    double dAdt = A * ((self.c_dadt/self.c_a)-(2/t));
    self.c_dzdt = (dAdt*(B-z)-B*(A+z+2*B*z)*t)/(3*z*z-2*z+A-B-B*B);
    
    double dzdp = self.c_dzdp;
    double dzdt = self.c_dzdt;
    
    Component *comp;
    
    free(_DLnPhiDP);
    _DLnPhiDP = (double *)calloc(self.components.count, sizeof(double));
    free(_DLnPhiDT);
    _DLnPhiDT = (double *)calloc(self.components.count, sizeof(double));
    
    for (int i = 0; i<self.components.count; i++) {
        comp = ((Component *)self.components[i]);
        _DLnPhiDP[i] = (comp.cubic_b * dzdp / self.c_b) + ((dzdp - (B/p))/(B-z)) + ((A/(z+B))*(1 - (comp.cubic_b/self.c_b))*((dzdp/z)-(1/p)));
        _DLnPhiDT[i] = (comp.cubic_b * dzdt / self.c_b) + ((dzdt - (B/t))/(B-z)) + ((A/(z+B))*(1 - (comp.cubic_b/self.c_b))*((dzdt/z)-(1/t)));
    }
}

- (void)dealloc {
    free(_DLnPhiDP);
    free(_DLnPhiDT);
    free(_c_kij);
    free(_componentLnPhi);
}

@end
