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
