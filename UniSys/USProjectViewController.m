//
//  USProjectViewController.m
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USProjectViewController.h"

#import "USNewProjectViewController.h"
#import "USComponentsViewController.h"

#import "USSettingViewController.h"
#import "USSteamTabBarController.h"
#import "USPropertiesSettingViewController.h"
#import "USCompositionSettingViewController.h"

#import "USEquipmentListView.h"
#import "EquipmentView.h"
#import "DraggableView.h"
#import "SteamView.h"

#import "USViewController.h"

@interface USProjectViewController () <USNewProjectViewControllerDelegate, USComponentsViewControllerDelegate, EquipmentListDelegate, EquipmentViewDelegate, USSettingViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) USEquipmentListView *equipmentList;

@end

@implementation USProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.equipmentList = [[USEquipmentListView alloc]init];
    self.equipmentList.listDelegate = self;
    [self.view addSubview:self.equipmentList];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*1.05, self.scrollView.frame.size.height*1.05);
    
    if (!self.actualProject) {
        [self performSegueWithIdentifier:@"New Segue" sender:nil];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EquipmentViewDelegate
- (void)equipmentViewClicked:(EquipmentView *)equipmentView {
    NSString *equipID = equipmentView.equipmentID;
    if ([equipmentView isKindOfClass:[SteamView class]]) {
        [self performSegueWithIdentifier:@"Steam Segue" sender:self.actualProject.totalSteams[equipID]];
    } else {
        // cambiar!!!!!
        [self performSegueWithIdentifier:@"Steam Segue" sender:self.actualProject.totalSteams[equipID]];
    }
    
}

#pragma mark - EquipmentListDelegate
- (void)equipmentList:(USEquipmentListView *)list addEquipment:(EquipmentTag)tag {
    
    NSString * equipId;
    if (tag == SteamTag) {
        equipId = [self.actualProject newSteam];
    } else {
        equipId = [self.actualProject newSteam];//equipId = [self.actualProject newEquipment:tag];
    }
    EquipmentView *equipment = [EquipmentView viewForEquipment:tag andID:equipId];
    equipment.delegate = self;
    [self.scrollView addSubview:equipment];
    NSLog(@"%lu",(unsigned long)self.scrollView.subviews.count);
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"PVT Segue"]) {
        
        USComponentsViewController *cvc = (USComponentsViewController *)((UINavigationController *)[segue destinationViewController]).topViewController;
        cvc.actualProject = self.actualProject;
        cvc.delegate = self;
        
    } else if ([[segue identifier] isEqualToString:@"New Segue"]) {
        
        USNewProjectViewController *npvc = [segue destinationViewController];
        npvc.delegate = self;
        
    } else if ([[segue identifier] isEqualToString:@"Steam Segue"]) {
        
        USSteamTabBarController *tabBar = ((USSteamTabBarController *)[segue destinationViewController]);
        if ([sender isKindOfClass:[Steam class]]) {
            tabBar.steam = (Steam *)sender;
        }
        ((USPropertiesSettingViewController *)tabBar.viewControllers[0]).delegate = self;
        ((USCompositionSettingViewController *)tabBar.viewControllers[1]).delegate = self;
    }
}

#pragma mark - USSettingViewControllerDelegate
- (void)settingControllerFinishEditing:(USSettingViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - USComponentsViewControllerDelegate
- (void)finishSetupWithCaseFile:(CaseFile *)file {
    self.actualProject = file;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - USNewProjectViewControllerDelegate

- (void)openNewCaseFile {
    
    self.actualProject = [[CaseFile alloc] init];
    
    [self performSegueWithIdentifier:@"New Segue" sender:nil];
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"PVT Segue" sender:nil];
    }];
}

- (void)openCaseFile:(CaseFile *)caseFile {
    
    self.actualProject = caseFile;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelNew {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
