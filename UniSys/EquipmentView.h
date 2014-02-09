//
//  EquipmentView.h
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "DraggableView.h"

@class EquipmentView;
@protocol EquipmentViewDelegate <NSObject>
- (void)equipmentViewClicked:(EquipmentView *)equipmentView;
@end

@interface EquipmentView : DraggableView

+ (NSArray *)equipmentsButtonImages;
+ (EquipmentView *)viewForEquipment:(EquipmentTag)equipment andID:(NSString *)equipID;

@property (nonatomic, weak) id <EquipmentViewDelegate> delegate;
@property (nonatomic, readonly) NSString * equipmentID;

@end
