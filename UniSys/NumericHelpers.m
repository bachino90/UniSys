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
    
    double error = 0.001;
    
    double c;
    double fa;
    double fb;
    double fc;
    
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
        }
    }
    
    results = [NSDictionary dictionaryWithObjectsAndKeys:@(c),@"ZEROS", nil];
    
    return results;
}

- (double)integrateSimpson:(FunctionBlock)functionBlock infLimit:(double)a supLimit:(double)b {
    double result = 0;
    
    
    
    return result;
}

@end
