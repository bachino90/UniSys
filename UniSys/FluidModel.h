//
//  FluidModel.h
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FluidModel : NSObject

- (instancetype)initModelWithType:(FluidModelType)type;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, readonly) FluidModelType type;
@property (nonatomic, readonly) BOOL isEOS;

+ (NSArray *)allModels;
+ (NSArray *)eosModels;
+ (NSArray *)activityModels;

@end
