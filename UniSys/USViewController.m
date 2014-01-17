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
@property (strong, nonatomic) RealFluid *fluido;
@end

@implementation USViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    Component *metano = [[Component alloc]initWithName:@"metano"];
    metano.composition = 0.5;
    Component *etano = [[Component alloc]initWithName:@"propano"];
    etano.composition = 0.5;
    
    self.fluido = [[RealFluid alloc] initWithComponents:@[metano, etano]];
    
    self.fluido.temperature = 250.0; //K
    self.fluido.pressure = 103025;   //Pa
    
    self.temperatureTextField.text = [NSString stringWithFormat:@"%f",self.fluido.temperature];
    self.pressureTextField.text = [NSString stringWithFormat:@"%f",self.fluido.pressure];
    
}

- (IBAction)calculate:(UIButton *)sender {
    self.fluido.temperature = [self.temperatureTextField.text doubleValue];
    self.fluido.pressure = [self.temperatureTextField.text doubleValue];
    [self.fluido calcPropertiesPT];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
