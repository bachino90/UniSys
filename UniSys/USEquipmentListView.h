//
//  USEquipmentListView.h
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USEquipmentListView;
@class EquipmentView;
@protocol EquipmentListDelegate <NSObject>
- (void)equipmentList:(USEquipmentListView *)list addEquipment:(EquipmentTag)equipmentTag;
@end

@interface USEquipmentListView : UIView

@property (nonatomic, weak) id <EquipmentListDelegate> listDelegate;

- (void)movePanelLeft;
- (void)movePanelRight;

@end
