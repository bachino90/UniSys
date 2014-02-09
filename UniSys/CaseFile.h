//
//  CaseFile.h
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"
#import "Steam.h"
#import "BaseEquipment.h"

@interface CaseFile : NSObject

// propiedades generales
@property (nonatomic, strong) NSMutableArray *components;
@property (nonatomic) FluidModelType model;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, readonly) NSInteger componentCount;

- (void)addComponent:(Component *)comp;
- (void)deleteComponent:(Component *)comp;

// propiedades de equipos y corrientes
@property (nonatomic, strong) NSMutableDictionary *totalSteams;
@property (nonatomic, strong) NSMutableDictionary *totalEquipments;

- (NSString *)newSteam;
- (NSString *)newEquipment:(EquipmentTag)tag;

@end
