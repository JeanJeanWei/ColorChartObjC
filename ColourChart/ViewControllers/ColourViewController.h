//
//  ColourViewController.h
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-01-11.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

typedef enum
{
    None,
    ActionBar,
    RGB,
    Both
} ControlStates;

@interface ColourViewController : ViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIControl *rgbInfo;
    IBOutlet UIControl *actionBar;
    
    IBOutlet UIButton *colorCodeBtn;
    IBOutlet UIButton *colorNameBtn;
    
    IBOutlet UILabel *tappedPoint;
    
    UIImageView *imageView;
    UIImage *image;
    UIImagePickerController *ipc;
    UIPopoverController *popover;
}

- (IBAction)hideRGB;
- (IBAction)hideActionBar;
- (IBAction)albumPressed;
- (IBAction)cameraPressed;

@end
