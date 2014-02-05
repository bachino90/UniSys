//
//  CaseFile.h
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"

@interface CaseFile : NSObject

@property (nonatomic, strong) NSMutableArray *components;
@property (nonatomic) FluidModelType model;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, readonly) NSInteger componentCount;

- (void)addComponent:(Component *)comp;
- (void)deleteComponent:(Component *)comp;

@end
