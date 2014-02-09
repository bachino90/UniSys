//
//  Component+UniSys.h
//  UniSys
//
//  Created by Emiliano Bivachi on 31/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Component.h"

@interface Component (UniSys)

/*
//Agregados cubicos
@property (nonatomic) double cubic_b;
@property (nonatomic) double cubic_a_const;
@property (nonatomic) double cubic_c_const;
@property (nonatomic) double cubic_k;
@property (nonatomic) double cubic_a; // a = a_const * (1+k*(1-sqrt(T/Tc))^2
@property (nonatomic) double cubic_c;
@property (nonatomic) double cubic_dadt;
@property (nonatomic) double cubic_PRSV_ki;

//agregados racket
@property (nonatomic) double zra;

//agregados para toods
@property (nonatomic) double composition;
@property (nonatomic) double phi;
*/

- (BOOL)isTheSame:(id)object;
+ (Component *)componentWithName:(NSString *)name;


@end
