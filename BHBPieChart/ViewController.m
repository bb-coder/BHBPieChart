//
//  ViewController.m
//  BHBPieChart
//
//  Created by bihongbo on 16/2/22.
//  Copyright © 2016年 bihongbo. All rights reserved.
//

#import "ViewController.h"
#import "BHBPieChart.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark -lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    BHBPieChart * pie = [[BHBPieChart alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 188)/2, 100, 188, 188)];
    [self.view addSubview:pie];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - <#UITableViewDelegate#> or <#UICollectionViewDelegate#>

#pragma mark - <#CustomDelegate#>

#pragma mark - event response

#pragma mark - private methods

#pragma mark - getters and setters

@end
