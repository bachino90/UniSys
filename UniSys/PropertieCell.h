//
//  PropertieCell.h
//  UniSys
//
//  Created by Emiliano Bivachi on 06/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertieCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *propertieName;
@property (nonatomic, weak) IBOutlet UILabel *propertieUnit;
@property (nonatomic, weak) IBOutlet UILabel *globalValue;
@property (nonatomic, weak) IBOutlet UILabel *vapourValue;
@property (nonatomic, weak) IBOutlet UILabel *liquidValue;


@end
