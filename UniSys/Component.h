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
@property (readonly) NSDictionary *cpIdealCoeff;

@property (nonatomic) double paramB;
@property (nonatomic) double paramA;

@property (nonatomic) double composition;
@property (nonatomic) double phi;

@end
