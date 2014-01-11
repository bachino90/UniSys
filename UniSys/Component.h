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

@property (readonly) double Tc;
@property (readonly) double Pc;
@property (readonly) double Vc;
@property (readonly) double Zc;
@property (readonly) double w;

@property (nonatomic) double comp;

@end
