//
//  MainViewController.m
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-01-27.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import "MainViewController.h"
#import "ColourViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) colorMatchClicked: (id) sender
{
    ColourViewController *vc = [ColourViewController new];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}

-(IBAction) imagePicklicked: (id) sender
{
    
}

@end
