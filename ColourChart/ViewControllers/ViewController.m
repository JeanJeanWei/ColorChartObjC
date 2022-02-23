//
//  ViewController.m
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-01-06.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController



- (id)init
{
    NSString* xibType = nil;
    
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        xibType = @"iPhone";
    }
    else
    {
        xibType = @"iPad";
    }
    
    NSString* xibName = [NSString stringWithFormat:@"%@-%@", self.class.description, xibType];
    
    NSString* path = [NSBundle.mainBundle pathForResource:xibName ofType:@"nib"];
    
    if (path)
    {
        self = [self initWithNibName:xibName bundle:nil];
    }
    else
    {
        self = [self initWithNibName:self.class.description bundle:nil];
    }
    
    return self;
}

- (void)roundView:(UIView*)view withRadius:(float)radius andStroke:(float)stroke andColor:(UIColor*)borderColor
{
    if (borderColor == nil)
    {
        borderColor = [UIColor grayColor];
    }
    view.layer.borderWidth = stroke;
    view.layer.borderColor = borderColor.CGColor;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = true;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(UIViewController *)childViewControllerForStatusBarHidden
{
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
