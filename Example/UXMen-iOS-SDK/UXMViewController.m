//
//  UXMViewController.m
//  UXMen-iOS-SDK
//
//  Created by git-erdinc-bakir on 07/07/2019.
//  Copyright (c) 2019 git-erdinc-bakir. All rights reserved.
//

#import <UXMen_iOS_SDK/UXMenSDK.h>
#import "UXMViewController.h"
#import "SecondViewController.h"

@interface UXMViewController ()

@end

@implementation UXMViewController {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	UXMenSDK *uxMenSdk = [UXMenSDK new];
    [uxMenSdk sayHello];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButton:(id)sender {
//    
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
//                                                                   message:@"This is an alert."
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    
//    [alert addAction:defaultAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
    SecondViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
