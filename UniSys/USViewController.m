//
//  USViewController.m
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USViewController.h"
#import "Component.h"
#import "RealFluid.h"

@interface USViewController ()
@property (weak, nonatomic) IBOutlet UITextField *temperatureTextField;
@property (weak, nonatomic) IBOutlet UITextField *pressureTextField;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UISwitch *isLiquidSwitch;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumenLabel;
@property (strong, nonatomic) RealFluid *fluido;
@property (strong, nonatomic) CubicGas *cubicFluido;
@end

@implementation USViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    Component *octano = [[Component alloc]initWithName:@"octano"];
    octano.composition = 1.0;
    Component *nonano = [[Component alloc]initWithName:@"nonano"];
    nonano.composition = 0.2;
    Component *decano = [[Component alloc]initWithName:@"decano"];
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
    Component *decano = [[Component alloc]initWithName:@"decano"];
    decano.composition = 0.8;
    Component *nonano = [[Component alloc]initWithName:@"nonano"];
    nonano.composition = 0.2;
    
    self.fluido = [[RealFluid alloc] initWithComponents:@[nonano, decano]];
    
    self.fluido.temperature = [self.temperatureTextField.text doubleValue];
    self.fluido.pressure = [self.pressureTextField.text doubleValue];
    [self.fluido calcPropertiesPT];
}

- (IBAction)calculate:(UIButton *)sender {
    Component *decano = [[Component alloc]initWithName:@"decano"];
    decano.composition = 0.8;
    Component *nonano = [[Component alloc]initWithName:@"nonano"];
    nonano.composition = 0.2;
    self.cubicFluido = [[CubicGas alloc] initWithComponents:@[decano,nonano] isLiquid:self.isLiquidSwitch.isOn];
    self.cubicFluido.temperature = [self.temperatureTextField.text doubleValue];
    self.cubicFluido.pressure = [self.pressureTextField.text doubleValue];
    //[self.fluido calcPropertiesPT];
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
