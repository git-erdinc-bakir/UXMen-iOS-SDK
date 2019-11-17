//
//  ListViewController.m
//  UXMen-iOS-SDK_Example
//
//  Created by E_BAKIR on 17.11.2019.
//  Copyright © 2019 git-erdinc-bakir. All rights reserved.
//

#import "ListViewController.h"
#import "UXMTableCell.h"

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tblListing;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tblListing.delegate = self;
    _tblListing.dataSource = self;
    
    [_tblListing reloadData];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UXMTableCell *cell = [_tblListing dequeueReusableCellWithIdentifier:@"UXMTableCell"];
    cell.lblTitle.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row ];
    
    return cell;
}


@end
