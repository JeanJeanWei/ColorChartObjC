//
//  MainViewController.h
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-01-27.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface MainViewController : ViewController
{
    IBOutlet UIButton *colorMatch;
    IBOutlet UIButton *imagePick;
}

-(IBAction) colorMatchClicked: (id) sender;
-(IBAction) imagePicklicked: (id) sender;

@end
