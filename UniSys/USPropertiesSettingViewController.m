//
//  USPropertiesSettingViewController.m
//  UniSys
//
//  Created by Emiliano Bivachi on 05/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USPropertiesSettingViewController.h"
#import "USSteamTabBarController.h"
#import "PropertieCell.h"
#import "Steam.h"
#import "Property.h"

@interface USPropertiesSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *vapourFractionBtn;
@property (weak, nonatomic) IBOutlet UIButton *temperatureBtn;
@property (weak, nonatomic) IBOutlet UIButton *pressureBtn;
@property (weak, nonatomic) IBOutlet UIButton *molarFlowBtn;
@property (weak, nonatomic) IBOutlet UIButton *massFlowBtn;

@property (weak, nonatomic) IBOutlet UIButton *unitTemperatureBtn;
@property (weak, nonatomic) IBOutlet UIButton *unitPressureBtn;
@property (weak, nonatomic) IBOutlet UIButton *unitMolarFlowBtn;
@property (weak, nonatomic) IBOutlet UIButton *unitMassFlowBtn;

@property (weak, nonatomic) IBOutlet UITableView *propertiesTableView;

@property (strong, nonatomic) Steam *steam;

@end

@implementation USPropertiesSettingViewController

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
    USSteamTabBarController *tabController = (USSteamTabBarController *)self.tabBarController;
    self.steam = tabController.steam;
    [self setNavBarTitle:tabController.steam.name];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.steam.properties.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PropertieCell";
    PropertieCell *cell = (PropertieCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Property *prop = self.steam.properties[indexPath.row];
    cell.propertieName.text = prop.name;
    cell.propertieUnit.text = prop.unit;
    cell.globalValue.text = prop.globalValue;
    cell.vapourValue.text = prop.vapourValue;
    cell.liquidValue.text = prop.liquidValue;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0;
}

@end
