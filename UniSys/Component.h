//
//  Component.h
//  UniSys
//
//  Created by Emiliano Bivachi on 11/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Component : NSObject

- (instancetype)initWithID:(NSInteger)id;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithNomenclature:(NSString *)nom;

@property (readonly) double tc;
@property (readonly) double pc;
@property (readonly) double vc;
@property (readonly) double zc;
@property (readonly) double w;
@property (nonatomic, strong, readonly) NSDictionary *cpIdealCoeff;

@property (nonatomic) double cubic_b;
@property (nonatomic) double cubic_a_const;
@property (nonatomic) double cubic_c_const;
@property (nonatomic) double cubic_k;
@property (nonatomic) double cubic_a; // a = a_const * (1+k*(1-sqrt(T/Tc))^2
@property (nonatomic) double cubic_c;
@property (nonatomic) double cubic_dadt;
@property (nonatomic) double cubic_PRSV_ki;

@property (nonatomic) double zra;

@property (nonatomic) double composition;
@property (nonatomic) double phi;

@end
