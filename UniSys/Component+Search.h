//
//  Component+Search.h
//  UniSys
//
//  Created by Emiliano Bivachi on 01/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Component.h"

@interface Component (Search)

+ (NSArray *)searchComponentByNameOrFormulaOrCasNum:(NSString *)comp;
+ (NSArray *)allComopnents;

@end
