//
//  UXMScrollViewController.m
//  UXMen-iOS-SDK_Example
//
//  Created by E_BAKIR on 17.11.2019.
//  Copyright © 2019 git-erdinc-bakir. All rights reserved.
//

#import "UXMScrollViewController.h"

@interface UXMScrollViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation UXMScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated{
    _scrollView.contentSize = CGSizeMake(0, 1000);
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
