//
//  FluidModel.m
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "FluidModel.h"

@interface FluidModel ()
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, readwrite) FluidModelType type;
@property (nonatomic, readwrite) BOOL isEOS;
@end

@implementation FluidModel

- (instancetype)initModelWithType:(FluidModelType)type {
    self = [super init];
    if (self) {
        _type = type;
        switch (type) {
            case Ideal:
                _name = @"Ideal gas";
                _isEOS = YES;
                break;
            case PR:
                _name = @"Peng Robinson";
                _isEOS = YES;
                break;
            case PRSV:
                _name = @"Stryjek and Vera";
                _isEOS = YES;
                break;
            case PRTwu:
                _name = @"PR Twu";
                _isEOS = YES;
                break;
            case RK:
                _name = @"Redlich Kwong";
                _isEOS = YES;
                break;
            case SRK:
                _name = @"Soave Redlich Kwong";
                _isEOS = YES;
                break;
            case SRKTwu:
                _name = @"SRK Twu";
                _isEOS = YES;
                break;
            case SRKKabadiDanner:
                _name = @"SRK Kabadi Danner";
                _isEOS = YES;
                break;
            case NRTL:
                _name = @"NRTL";
                _isEOS = NO;
                break;
            case vanLaar:
                _name = @"van Laar";
                _isEOS = NO;
                break;
            case Wilson:
                _name = @"Wilson";
                _isEOS = NO;
                break;
            case Margules:
                _name = @"Margules";
                _isEOS = NO;
                break;
            case UNIQUAC:
                _name = @"UNIQUAC";
                _isEOS = NO;
                break;
            default:
                break;
        }
    }
    return self;
}

+ (NSArray *)allModels {
    NSMutableArray *models = [[NSMutableArray alloc]init];
    for (int i=0; i<=UNIQUAC; i++) {
        FluidModel *mod = [[FluidModel alloc]initModelWithType:i];
        [models addObject:mod];
    }
    return [models copy];
}

+ (NSArray *)eosModels {
    NSMutableArray *models = [[NSMutableArray alloc]init];
    for (int i=0; i<=UNIQUAC; i++) {
        FluidModel *mod = [[FluidModel alloc]initModelWithType:i];
        if (mod.isEOS) {
            [models addObject:mod];
        }
    }
    return [models copy];
}

+ (NSArray *)activityModels {
    NSMutableArray *models = [[NSMutableArray alloc]init];
    for (int i=0; i<=UNIQUAC; i++) {
        FluidModel *mod = [[FluidModel alloc]initModelWithType:i];
        if (!mod.isEOS) {
            [models addObject:mod];
        }
    }
    return [models copy];
}

@end
