//
//  RealGas.h
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealGas : NSObject 

- (instancetype)initWithType:(FluidModelType)type andComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid;

@property (nonatomic, readonly) NSString *modelName;
@property (nonatomic, readonly) FluidModelType modelType;

- (NSString *)modelNameForType:(FluidModelType)type;

@end
