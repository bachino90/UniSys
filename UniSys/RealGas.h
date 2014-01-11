//
//  RealGas.h
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealGas : NSObject {
    NSInteger P;
    NSInteger T;
    NSInteger v;
}

- (instancetype)initWithComponents:(NSArray *)comp;

@property (nonatomic) double pressure; //    Pa
@property (nonatomic) double temperature; // K
@property (nonatomic) double volumen; //     m3/mol
@property (nonatomic) NSArray *composition;

@end
