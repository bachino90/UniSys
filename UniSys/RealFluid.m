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

@property (nonatomic, strong, readwrite) CubicGas *gas;
@property (nonatomic, strong, readwrite) CubicGas *liquid;

@end

@implementation RealFluid

- (instancetype)initWithComponents:(NSArray *)comp {
    self = [super init];
    if (self) {
        self.components = comp;
    }
    return self;
}

- (BOOL)isDeterminated {
    return (((self.temperature > 0 && self.pressure > 0) ||
            (self.vaporRatio > 0 && self.temperature > 0) ||
            (self.vaporRatio > 0 && self.pressure > 0))
            && (self.components && self.components.count>0));
}

- (double)molarEnthalpy {
    return (self.vaporRatio * self.gas.enthalpy + (1-self.vaporRatio) * self.liquid.enthalpy);
}

- (double)molarEntropy {
    return (self.vaporRatio * self.gas.entropy + (1-self.vaporRatio) * self.liquid.entropy);
}

- (double)volumen {
    return (self.vaporRatio * self.gas.volumen + (1-self.vaporRatio) * self.liquid.volumen);
}

- (double)wilsonKForComponent:(Component *)comp pressure:(double)p andTemperature:(double)t {
    double pc = comp.pc;
    double tc = comp.tc;
    double tr = tc/t;
    double w = comp.w;
    double Psat = pc * exp(5.373 * (1+comp.w) * (1-(comp.tc/t)));
    double k = Psat/p;
    double ll = 1.0;
    return k;
}

- (void)calcPropertiesPT {
    if (!self.isDeterminated)
        return;
    
    [self calcFlashPT];
    
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
        self.gas = [[CubicGas alloc] initWithComponents:self.components isLiquid:NO];
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
        self.liquid = [[CubicGas alloc] initWithComponents:self.components isLiquid:YES];
        self.liquid.temperature = self.temperature;
        self.liquid.pressure = self.pressure;
        [self.liquid checkDegreeOfFreedom];
    }
}

- (void)calcPropertiesTVaporRatio {
    if (self.vaporRatio == 0.0) {   // Punto de burbuja
        self.pressure = [self calcBubbleP];
    } else if (self.vaporRatio == 1.0) {  // Punto de Rocio
        self.pressure = [self calcDewP];
    } else if (self.vaporRatio > 0.0 && self.vaporRatio < 1.0) {  // Equilibrio
        
    }
}

- (void)calcPropertiesPVaporRatio {
    if (self.vaporRatio == 0.0) {   // Punto de burbuja
        self.temperature = [self calcBubbleT];
    } else if (self.vaporRatio == 1.0) {  // Punto de Rocio
        self.temperature = [self calcDewT];
    } else if (self.vaporRatio > 0.0 && self.vaporRatio < 1.0) {  // Equilibrio
        
    }
}

- (void)initializeComponentKiWithPressure:(double)pressure {
    free(_componentKi);
    free(_liquidComposition);
    free(_gasComposition);
    _componentKi = (double *)calloc(self.components.count,sizeof(double));
    _liquidComposition = (double *)calloc(self.components.count,sizeof(double));
    _gasComposition = (double *)calloc(self.components.count,sizeof(double));
    for (int i=0; i<self.components.count; i++) {
        Component *comp = self.components[i];
        _componentKi[i] = [self wilsonKForComponent:comp pressure:pressure andTemperature:self.temperature];
    }
    
}

#pragma mark - Flash PT

- (void)calcFlashPT {
    if (YES)
        [self calcFlashPT_phiphi];
    else
        [self calcFlashPT_gammphi];
}

- (void)calcFlashPT_gammphi {
    #warning Falta Flash PT gamma/phi
}

- (void)calcFlashPT_phiphi {
    if (!self.isDeterminated)
        return;
    
    [self initializeComponentKiWithPressure:self.pressure];
    
    double xi[self.components.count];
    double yi[self.components.count];
    
    FunctionBlock betaFunction = ^(double beta) {
        __block double f = 0;
        double *ki = _componentKi;
        [self.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Component *comp = (Component *)obj;
            f += ((ki[idx]-1) * comp.composition)/(1+beta*(ki[idx]-1));
            NSLog(@"ki: %g",ki[idx]);
        }];
        NSLog(@"beta: %g || f: %g",beta,f);
        return f;
    };
    
    FunctionBlock derivateBetaFunction = ^(double beta) {
        __block double f = 0;
        double *ki = _componentKi;
        [self.components enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Component *comp = (Component *)obj;
            f += ((ki[idx]-1) * (ki[idx]-1) * comp.composition)/((1+beta*(ki[idx]-1))*(1+beta*(ki[idx]-1)));
            NSLog(@"ki: %g",ki[idx]);
        }];
        NSLog(@"beta: %g || f: %g",beta,f);
        return -f;
    };
    
    CubicGas *gasB = [[CubicGas alloc] initWithComponents:self.components isLiquid:NO];
    CubicGas *liquidB = [[CubicGas alloc] initWithComponents:self.components isLiquid:YES];
    
    liquidB.temperature = self.temperature;
    liquidB.pressure = self.pressure;
    gasB.temperature = self.temperature;
    gasB.pressure = self.pressure;
    
    double beta = 0.5;
    
    // Ejemplo ***************
    // T=400K P=30kPa beta=0.4
    //_componentKi[0] = 0.8699; //decano 0.8
    //_componentKi[1] = 1.704;  //nonano 0.2
    
    do {
        //NSDictionary *results = [[NumericHelpers sharedInstance] regulaFalsiMethod:betaFunction infLimit:-0.01 supLimit:1.01];
        NSDictionary *results = [[NumericHelpers sharedInstance] newtonRaphsonMethod:betaFunction derivate:derivateBetaFunction initValue:beta];
        beta = [results[@"ZEROS"] doubleValue];
        
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            double *ki = _componentKi;
            xi[i] = comp.composition / (1+beta * (ki[i]-1));
            yi[i] = ki[i] * comp.composition / (1+beta * (ki[i]-1));
            NSLog(@"x[%i] = %g || y[%i] = %g",i,xi[i],i,yi[i]);
        }
        
        liquidB.composition = xi;
        [liquidB checkDegreeOfFreedom];
        
        gasB.composition = yi;
        [gasB checkDegreeOfFreedom];
        
        for (int i=0; i<self.components.count; i++) {
            _componentKi[i] = exp(liquidB.componentLnPhi[i])/exp(gasB.componentLnPhi[i]);
        }
        
    } while ([self compareOldXi:xi andOldYi:yi]);
    
    self.liquidComposition = xi;
    self.gasComposition = yi;
    self.vaporRatio = beta;
    
    self.gas = gasB;
    self.liquid = liquidB;
}

#pragma mark - Dew P

- (double)calcDewP {
    if (YES)
        return [self calcDewP_phiphi];
    else
        return [self calcDewP_gammaphi];
}

- (double)calcDewP_phiphi {
    #warning Falta Bubble P phi/phi
    double gasComp[self.components.count];
    for (int i=0; i<self.components.count; i++) {
        Component *comp = self.components[i];
        gasComp[i] = comp.composition;
    }
    
    
    return 0;
}

- (double)calcDewP_gammaphi {
    #warning Falta Dew P gamma/phi
    
    return 0;
}

#pragma mark - Bubble P

- (double)calcBubbleP {
    if (YES)
        return [self calcBubbleP_phiphi];
    else
        return [self calcBubbleP_gammaphi];
}

- (double)calcBubbleP_gammaphi {
#warning Falta Bubble P gamma/phi
    return 0;
}

- (double)calcBubbleP_phiphi {
    double liquidComp[self.components.count];
    for (int i=0; i<self.components.count; i++) {
        Component *comp = self.components[i];
        liquidComp[i] = comp.composition;
    }
    
    double F;
    double dFdP;
    double Pj = 10000;//[self initializeSaturatePressureForTemperature:self.temperature];
    double Pj1 = Pj;
    
    [self initializeComponentKiWithPressure:Pj];
    
    CubicGas *gasB;
    gasB = [[CubicGas alloc] initWithComponents:self.components isLiquid:NO];
    gasB.temperature = self.temperature;
    
    CubicGas *liquidB;
    liquidB = [[CubicGas alloc] initWithComponents:self.components isLiquid:YES];
    liquidB.temperature = self.temperature;
    liquidB.composition = liquidComp;
    
    /*
    double Kixi_1 = 0;
    double Kixi_2 = 1;
    do {
        Pj = Pj1;
        
        liquidB.pressure = Pj;
        [liquidB checkDegreeOfFreedom];
        
        while (ABS(Kixi_1 - Kixi_2)>0.01) {
            
            double gasComp[self.components.count];
            Kixi_1 = 0;
            for (int i=0; i<self.components.count; i++) {
                Component *comp = self.components[i];
                _componentKi[i] = exp(liquidB.componentLnPhi[i]);
                gasComp[i] = comp.composition * _componentKi[i];
                Kixi_1 += gasComp[i];
                NSLog(@"%g",_componentKi[i]);
                NSLog(@"%g",gasComp[i]);
            }
            for (int j=0; j<self.components.count; j++) {
                gasComp[j] = gasComp[j]/Kixi_1;
                NSLog(@"normalizada :%g",gasComp[j]);
            }
            
            gasB.pressure = Pj;
            gasB.composition = gasComp;
            [gasB checkDegreeOfFreedom];
            
            Kixi_2 = 0;
            for (int i=0; i<self.components.count; i++) {
                _componentKi[i] = exp(liquidB.componentLnPhi[i] - gasB.componentLnPhi[i]);
                NSLog(@"%g",_componentKi[i]);
                Kixi_2 += gasComp[i] * _componentKi[i];
            }
            
        }
        Kixi_2 = 1;
        Kixi_1 = 0;
        
        double *gasDlnphiDP = gasB.DLnPhiDP;
        double *liquidDlnphiDP = liquidB.DLnPhiDP;
        F = -1;
        dFdP = 0;
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            _componentKi[i] = exp(liquidB.componentLnPhi[i] - gasB.componentLnPhi[i]);
            NSLog(@"%g",_componentKi[i]);
            F += comp.composition * _componentKi[i];
            dFdP += comp.composition * _componentKi[i] * (liquidDlnphiDP[i] - gasDlnphiDP[i]);
        }
        
        Pj1 = Pj - F/dFdP;
        
    } while (ABS(Pj1-Pj)>0.1);
    */
    
    do {
        Pj = Pj1;
        
        double gasComp[self.components.count];
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            gasComp[i] = comp.composition * _componentKi[i];
            NSLog(@"%g",_componentKi[i]);
            NSLog(@"%g",gasComp[i]);
        }
        [self normalizeComposition:gasComp];
        
        gasB.pressure = Pj;
        gasB.composition = gasComp;
        [gasB checkDegreeOfFreedom];
        double *gasDlnphiDP = gasB.DLnPhiDP;
        
        liquidB.pressure = Pj;
        [liquidB checkDegreeOfFreedom];
        double *liquidDlnphiDP = liquidB.DLnPhiDP;
        
        F = -1;
        dFdP = 0;
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            _componentKi[i] = exp(liquidB.componentLnPhi[i] - gasB.componentLnPhi[i]);
            NSLog(@"%g",_componentKi[i]);
            F += comp.composition * _componentKi[i];
            dFdP += comp.composition * _componentKi[i] * (liquidDlnphiDP[i] - gasDlnphiDP[i]);
        }
        
        Pj1 = Pj - F/dFdP;
        
    } while (ABS(Pj1-Pj)>0.1);
    
    /*
    Pj = 100;
    for (int i=0; i<400; i++) {
        double gasComp[self.components.count];
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            gasComp[i] = comp.composition * _componentKi[i];
            NSLog(@"%g",_componentKi[i]);
            NSLog(@"%g",gasComp[i]);
        }
        [self normalizeComposition:gasComp];
        
        gasB.pressure = Pj;
        gasB.composition = gasComp;
        [gasB checkDegreeOfFreedom];
        double *gasDlnphiDP = gasB.DLnPhiDP;
        
        liquidB.pressure = Pj;
        [liquidB checkDegreeOfFreedom];
        double *liquidDlnphiDP = liquidB.DLnPhiDP;
        
        F = -1;
        dFdP = 0;
        for (int i=0; i<self.components.count; i++) {
            Component *comp = self.components[i];
            _componentKi[i] = exp(liquidB.componentLnPhi[i] - gasB.componentLnPhi[i]);
            NSLog(@"K[%i] = %g",i,_componentKi[i]);
            F += comp.composition * _componentKi[i];
            dFdP += comp.composition * _componentKi[i] * (liquidDlnphiDP[i] - gasDlnphiDP[i]);
        }
        
        NSLog(@"P = %g ||F = %g",Pj,F);
        Pj += 5000;
    }
    */
    return Pj1;
}

#pragma mark - Dew T

- (double)calcDewT {
    if (YES)
        return [self calcDewT_phiphi];
    else
        return [self calcDewT_gammaphi];
}

- (double)calcDewT_phiphi {
#warning Falta Bubble T phi/phi

    return 0;
}

- (double)calcDewT_gammaphi {
#warning Falta Dew T gamma/phi
    
    return 0;
}

#pragma mark - Bubble T

- (double)calcBubbleT {
    if (YES)
        return [self calcBubbleT_phiphi];
    else
        return [self calcBubbleT_gammaphi];
}

- (double)calcBubbleT_gammaphi {
#warning Falta Bubble T gamma/phi
    
    return 0;
}

- (double)calcBubbleT_phiphi {
#warning Falta Bubble T phi/phi

    return 0;
}

#pragma mark - Auxiliares

- (double)initializeSaturatePressureForTemperature:(double)temp {
    //Dong and Lienhard
    double p=0;
    for (int i=0; i<self.components.count; i++) {
        Component *comp = self.components[i];
        double tr = temp/comp.tc;
        double lnPrSat = 5.3727*(1-tr)+comp.w*(7.49408 - 11.18177*pow(tr, 3) + 3.68769 * pow(tr, 6) + 17.92998 * log(tr));
        p+= comp.composition * exp(lnPrSat) * comp.pc;
    }
    return p;
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

- (void)normalizeComposition:(double *)comp {
    double total = 0;
    for (int i=0; i<self.components.count; i++) {
        total += comp[i];
    }
    
    for (int j=0; j<self.components.count; j++) {
        comp[j] = comp[j]/total;
        NSLog(@"normalizada :%g",comp[j]);
    }
}

@end
