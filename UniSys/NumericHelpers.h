//
//  NumericHelpers.h
//  UniSys
//
//  Created by Emiliano Bivachi on 14/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef double (^FunctionBlock) (double);

@interface NumericHelpers : NSObject

+ (instancetype)sharedInstance;

- (double *)solveCubicEquationZ3:(double)a Z2:(double)b Z:(double)c;
- (NSDictionary *)regulaFalsiMethod:(FunctionBlock)function infLimit:(double)a supLimit:(double)b;
- (NSDictionary *)newtonRaphsonMethod:(FunctionBlock)functionBlock derivate:(FunctionBlock)derivateBlock initValue:(double)a;
- (NSDictionary *)puntoFijoMethod:(FunctionBlock)functionBlock initValue:(double)a;
- (NSDictionary *)puntoFijoMethod:(FunctionBlock)functionBlock initValue:(double)a infLimit:(double)inf supLimit:(double)sup;

@end
