//
//  USViewController.m
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USViewController.h"
#import "Component.h"
#import "Component+UniSys.h"
#import "RealFluid.h"

@interface USViewController ()
@property (weak, nonatomic) IBOutlet UITextField *temperatureTextField;
@property (weak, nonatomic) IBOutlet UITextField *pressureTextField;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UISwitch *isLiquidSwitch;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumenLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectComponent;
@property (strong, nonatomic) RealFluid *fluido;
@property (strong, nonatomic) CubicGas *cubicFluido;
@end

@implementation USViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    Component *octano = [Component componentWithName:@"octano"];
    octano.composition = 1.0;
    Component *nonano = [Component componentWithName:@"nonano"];
    nonano.composition = 0.2;
    Component *decano = [Component componentWithName:@"decano"];
    decano.composition = 0.2;
    
    /*
    self.fluido = [[RealFluid alloc] initWithComponents:@[octano, nonano, decano]];
    
    self.fluido.temperature = 250.0; //K
    self.fluido.pressure = 101325;   //Pa
    */
    //self.cubicFluido = [[CubicGas alloc] initWithComponents:@[octano]];
    //self.temperatureTextField.text = [NSString stringWithFormat:@"%f",self.fluido.temperature];
    //self.pressureTextField.text = [NSString stringWithFormat:@"%f",self.fluido.pressure];
    
}

- (IBAction)calculateFluid:(UIButton *)sender {
    Component *decano = [Component componentWithName:@"decano"];
    decano.composition = 0.8;
    Component *nonano = [Component componentWithName:@"nonano"];
    nonano.composition = 0.2;
    
    self.fluido = [[RealFluid alloc] initWithComponents:@[decano, nonano]];
    
    self.fluido.temperature = [self.temperatureTextField.text doubleValue];
    self.fluido.pressure = [self.pressureTextField.text doubleValue];
    [self.fluido calcPropertiesPT];
}

- (IBAction)calculate:(UIButton *)sender {
    NSArray *components;
    if (self.selectComponent.selectedSegmentIndex == 0) {
        Component *decano = [Component componentWithName:@"decano"];
        decano.composition = 1.0;
        components = @[decano];
        self.cubicFluido = [[CubicGas alloc] initWithComponents:components isLiquid:self.isLiquidSwitch.isOn];
    } else if (self.selectComponent.selectedSegmentIndex == 1) {
        Component *decano2 = [Component componentWithName:@"decano"];
        decano2.composition = 0.8;
        Component *nonano = [Component componentWithName:@"nonano"];
        nonano.composition = 0.2;
        components = @[decano2, nonano];
        self.cubicFluido = [[CubicGas alloc] initWithComponents:components isLiquid:self.isLiquidSwitch.isOn];
    } else if (self.selectComponent.selectedSegmentIndex == 2) {
        Component *nitrogeno = [Component componentWithName:@"nitrogeno"];
        nitrogeno.composition = 0.4;
        Component *metano = [Component componentWithName:@"metano"];
        metano.composition = 0.6;
        components = @[nitrogeno, metano];
        self.cubicFluido = [[CubicGas alloc] initWithType:RK andComponents:components isLiquid:self.isLiquidSwitch.isOn];
    } else if (self.selectComponent.selectedSegmentIndex == 3) {
        Component *metano = [Component componentWithName:@"metano"];
        metano.composition = 0.5;
        Component *butano = [Component componentWithName:@"butano"];
        butano.composition = 0.5;
        components = @[metano, butano];
        self.cubicFluido = [[CubicGas alloc] initWithType:SRK andComponents:components isLiquid:self.isLiquidSwitch.isOn];
    } else if (self.selectComponent.selectedSegmentIndex == 4) {
        Component *propano = [Component componentWithName:@"propano"];
        propano.composition = 1.0;
        components = @[propano];
        self.cubicFluido = [[CubicGas alloc] initWithType:RK andComponents:components isLiquid:self.isLiquidSwitch.isOn];
    }
    
    self.cubicFluido.temperature = [self.temperatureTextField.text doubleValue];
    self.cubicFluido.pressure = [self.pressureTextField.text doubleValue];
    [self.cubicFluido checkDegreeOfFreedom];
    
    self.zLabel.text = [NSString stringWithFormat:@"%g",self.cubicFluido.z];
    self.volumenLabel.text = [NSString stringWithFormat:@"%g", self.cubicFluido.volumen];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
