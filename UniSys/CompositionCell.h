//
//  CompositionCell.h
//  UniSys
//
//  Created by Emiliano Bivachi on 07/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompositionCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *componentName;
@property (nonatomic, weak) IBOutlet UILabel *kValue;
@property (nonatomic, weak) IBOutlet UILabel *globalComposition;
@property (nonatomic, weak) IBOutlet UILabel *vapourComposition;
@property (nonatomic, weak) IBOutlet UILabel *liquidComposition;

@end
