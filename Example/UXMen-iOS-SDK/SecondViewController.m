//
//  SecondViewController.m
//  sampleapp
//
//  Created by E_BAKIR on 25.04.2019.
//  Copyright © 2019 E_BAKIR. All rights reserved.
//

#import "SecondViewController.h"
#import "ListViewController.h"
#import "UXMScrollViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionScroll:(id)sender {
    UXMScrollViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UXMScrollViewController"];
    [self presentViewController:modalVC animated:YES completion:nil];
}

- (IBAction)actionModal:(id)sender {
    ListViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    [self presentViewController:modalVC animated:YES completion:nil];
}

@end
