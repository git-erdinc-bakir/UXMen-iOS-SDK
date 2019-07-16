//
//  UXMViewController.m
//  UXMen-iOS-SDK
//
//  Created by git-erdinc-bakir on 07/07/2019.
//  Copyright (c) 2019 git-erdinc-bakir. All rights reserved.
//

#import <UXMen_iOS_SDK/UXMenSDK.h>
#import <UXMen_iOS_SDK/UXMenAPI.h>
#import "UXMViewController.h"

@interface UXMViewController ()

@end

@implementation UXMViewController {
    UXMenAPI *uxMenApi;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	UXMenSDK *uxMenSdk = [UXMenSDK new];
    [uxMenSdk sayHello];

    uxMenApi = [UXMenAPI new];
    [uxMenApi configure];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
