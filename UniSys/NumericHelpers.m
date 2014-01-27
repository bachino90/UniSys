//
//  NumericHelpers.m
//  UniSys
//
//  Created by Emiliano Bivachi on 14/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "NumericHelpers.h"

@implementation NumericHelpers

+ (instancetype)sharedInstance {
    static NumericHelpers *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


// f(z) = z3 + a*z2 + b*z +c
- (double *)solveCubicEquationZ3:(double)a Z2:(double)b Z:(double)c {
    
    double *x = NULL;
    double Q = (3*b - pow(a,2))/9.0;
    double R = (9*a*b-27*c-2*pow(a, 3))/54.0;
    double R2 = pow(R, 2.0);
    double Q3 = pow(Q, 3.0);
    double D = Q3 + R2;
        
    NSLog(@"Solucion Cubica");
    if (ABS(D) < 1E-15) {
        x = (double*)calloc(3, sizeof(double));
        x[0] = 2;
        double exp = 1/3.0;
        double S1 = pow(R+sqrt(D), exp);
        double S2 = pow(R-sqrt(D), exp);
        x[1] = S1 + S2 - a/3.0;
        x[2] = -((S1 + S2)/2.0) - a/3.0;
        NSLog(@"2 : %g",x[1]);
        NSLog(@"F : %g",x[1]*x[1]*x[1] + a*x[1]*x[1] + b*x[1] + c);
        NSLog(@"3 : %g",x[2]);
        NSLog(@"F : %g",x[2]*x[2]*x[2] + a*x[2]*x[2] + b*x[2] + c);
    } else if (D > 0) {
        x = (double *)calloc(2, sizeof(double));
        x[0] = 1;
        double S1 = pow(ABS(R) + sqrt(D), 1/3.0);
        if (R<0)
            S1 = -S1;
        
        double S2 = 0;
        if (S1 != 0)
            S2 = -Q/S1;
        
        x[1] = S1 + S2 - a/3.0;
        NSLog(@"2 : %g",x[1]);
        NSLog(@"F : %g",x[1]*x[1]*x[1] + a*x[1]*x[1] + b*x[1] + c);
    } else {
        x = (double *)calloc(4, sizeof(double));
        x[0] = 3;
        double phi = acos(R/sqrt(-pow(Q, 3)));
        x[1] = 2*sqrt(-Q)*cos(phi/3) - a/3.0;
        x[2] = 2*sqrt(-Q)*cos((phi+4*M_PI)/3) - a/3.0;
        x[3] = 2*sqrt(-Q)*cos((phi+2*M_PI)/3) - a/3.0;
        NSLog(@"2 : %g",x[1]);
        NSLog(@"F : %g",x[1]*x[1]*x[1] + a*x[1]*x[1] + b*x[1] + c);
        NSLog(@"3 : %g",x[2]);
        NSLog(@"F : %g",x[2]*x[2]*x[2] + a*x[2]*x[2] + b*x[2] + c);
        NSLog(@"1 : %g",x[3]);
        NSLog(@"F : %g",x[3]*x[3]*x[3] + a*x[3]*x[3] + b*x[3] + c);
    }
    
    return x;
}

- (NSDictionary *)regulaFalsiMethod:(FunctionBlock)functionBlock infLimit:(double)a supLimit:(double)b {
    NSDictionary *results;
    
    double error = 0.000001;
    
    double c;
    double fa;
    double fb;
    double fc=1;
    BOOL isThereAZero = YES;
    
    while (ABS(fc) > error) {
        fa = functionBlock(a);
        fb = functionBlock(b);
        c = b - (fb * (b - a)/(fb - fa));
        fc = functionBlock(c);
        if (fa * fc < 0) {
            b = c;
        } else if (fb * fc < 0) {
            a = c;
        } else if (fc == 0) {
            break;
        } else if ((fa > 0 && fb > 0) || (fa < 0 && fb < 0)) {
            isThereAZero = NO;
            break;
        }
    }
    
    if (isThereAZero) {
        results = [NSDictionary dictionaryWithObjectsAndKeys:@(c),@"ZEROS",@(YES),@"Hay zero?", nil];
    } else {
        results = [NSDictionary dictionaryWithObjectsAndKeys:@(NO),@"Hay zero?", nil];
    }
    
    
    return results;
}

- (NSDictionary *)puntoFijoMethod:(FunctionBlock)functionBlock initValue:(double)a {
    
    NSDictionary *results;
    
    double error = 0.000001;
    
    double z = a+1;
    double zi = a;
    
    while (ABS(z-zi) > error) {
        z = zi;
        zi = functionBlock(z);
    }
    
    results = [NSDictionary dictionaryWithObjectsAndKeys:@(zi),@"ZEROS",@(YES),@"Hay zero?", nil];
    
    return results;
}

- (NSDictionary *)puntoFijoMethod:(FunctionBlock)functionBlock initValue:(double)a infLimit:(double)inf supLimit:(double)sup {
    
    NSDictionary *results;
    
    double error = 0.000001;
    
    double z = a+1;
    double zi = a;
    NSString *errMessage = @"";
    BOOL thereIsZero = YES;

    while (ABS(z-zi) > error) {
        z = zi;
        zi = functionBlock(z);
        if (zi<inf) {
            errMessage = @"INF_ERROR";
            thereIsZero = NO;
            break;
        } else if (zi>sup) {
            errMessage = @"SUP_ERROR";
            thereIsZero = NO;
            break;
        }
    }
    
    results = [NSDictionary dictionaryWithObjectsAndKeys:@(zi),@"ZEROS",@(thereIsZero),@"Hay zero?",errMessage,@"MESSAGE", nil];
    
    return results;
}

- (NSDictionary *)newtonRaphsonMethod:(FunctionBlock)functionBlock derivate:(FunctionBlock)derivateBlock initValue:(double)a {
    NSDictionary *results;
    
    double error = 0.001;
    
    double z = a+1;
    double zi = a;
    
    while (ABS(z-zi) > error) {
        z = zi;
        zi = z - functionBlock(z)/derivateBlock(z);
    }
    
    results = [NSDictionary dictionaryWithObjectsAndKeys:@(zi),@"ZEROS", nil];
    
    return results;
}

- (double)integrateSimpson:(FunctionBlock)functionBlock infLimit:(double)a supLimit:(double)b {
    double result = 0;
    
    
    
    return result;
}

@end
