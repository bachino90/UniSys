//
//  USSettingViewController.h
//  UniSys
//
//  Created by Emiliano Bivachi on 05/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USSettingViewController;
@protocol USSettingViewControllerDelegate <NSObject>
- (void)settingControllerFinishEditing:(USSettingViewController *)vc;
@end

@interface USSettingViewController : UIViewController

@property (nonatomic, weak) id <USSettingViewControllerDelegate> delegate;

- (void)setNavBarTitle:(NSString *)title;

@end
