//
//  MagViewController.m
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-04-08.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import "MagViewController.h"

@implementation MagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)dismissModelView
{
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
