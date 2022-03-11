//
//  ColourViewController.m
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-01-11.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import "ColourViewController.h"
#import "ColorCodeController.h"
#import "UIImage+Picker.h"
#import "MagViewController.h"

#import "CancellableOperation.h"
#import "OperationQueueManager.h"

@implementation ColourViewController

const float MINIMUM_SCALE = 0.1;
const float MAXIMUM_SCALE = 1.5;

const int MARGIN = 14;
const int StatusBar = 44;
const int BOTTON_BAR_HEIGHT = 100;
const int SIDE_BAR_WIDTH = 122;
const int ACTION_BAR_WIDTH = 110;
ControlStates controlState = None;
CGPoint abPoint;
int viewWidth;
int viewHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ipc = [UIImagePickerController new];
    ipc.delegate = self;

    image = [UIImage imageNamed:@"color chart.png"];
    
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    imageView = [[UIImageView alloc] initWithFrame:frame];
    
    scrollView.contentSize = imageView.frame.size;
    //scrollView.alpha = 0;
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [scrollView addSubview:imageView];
    [self roundView:scrollView withRadius:10 andStroke:5 andColor:[UIColor whiteColor]];
    [self roundView:self.view withRadius:10 andStroke:5 andColor:[UIColor clearColor]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tapRecognizer];
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [imageView addGestureRecognizer:pinchRecognizer];
    
    // swip gestures
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];

    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    viewWidth = GET_WIDTH(self.view.frame);
    viewHeight = GET_HEIGHT(self.view.frame);
    [self prepareView];
}

- (void)prepareView
{
    // reset page status to default values
    tappedPoint.hidden = true;
    [tappedPoint setTitle:@"" forState:UIControlStateNormal];
    [colorCodeBtn setTitle:@"R:G:B:" forState:UIControlStateNormal];
    [colorNameBtn setTitle:@"" forState:UIControlStateNormal];
    [scrollView setBackgroundColor:[UIColor blackColor]];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
//    if (scrollView.alpha == 0.5)
//    {
//        scrollView.alpha = 1;
//        return;
//    }
    CGFloat w = GET_WIDTH(scrollView.frame) > viewWidth-MARGIN*2 ? viewWidth-MARGIN*2 : GET_WIDTH(scrollView.frame);
    CGFloat h = GET_HEIGHT(scrollView.frame) > viewHeight-MARGIN*2 ? viewHeight-MARGIN*2 : GET_HEIGHT(scrollView.frame);
    
    CGFloat newScaleW = w/imageView.frame.size.width;
    CGFloat newScaleH = h/imageView.frame.size.height;
    CGFloat newScale = newScaleW > newScaleH ? newScaleH : newScaleW;
    NSLog(@"newScale = %f", newScale);
    CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
    if (iPHONE)
        [self doTransform:transform];
    else
        [self doTransformIPAD:transform];
    // menu
    [self layoutMenu];
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe
{
    float xPos = iPHONE ? [swipe locationInView:self.view].x : [swipe locationInView:self.view].y;
    
    switch (swipe.direction)
    {
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"Swipe Left");
            if (iPHONE)
            {
                if (xPos < viewWidth/2) [self showRGB:false];
                else [self showAction:true];
            }
            else
            {
                if (xPos < viewHeight/2) [self showRGB:false];
                else [self showAction:false];
            }
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"Swipe Right");
            if (iPHONE)
            {
                if (xPos < viewWidth/2) [self showRGB:true];
                else [self showAction:false];
            }
            else
            {
                if (xPos < viewHeight/2) [self showRGB:true];
                else [self showAction:true];
            }
            break;
            
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"Swipe Up");
                        break;
            
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"Swipe Down");
            
            break;
            
            
        default:
            break;
    }
}

- (IBAction)hideRGB
{
    [self showRGB:false];
}

- (IBAction)hideActionBar
{
    [self showAction:false];
}

- (void)showRGB:(BOOL)rgb 
{
    switch (controlState)
    {
        case None:
            if (rgb) controlState = RGB;
            break;
            
        case RGB:
            if (!rgb) controlState = None;
            break;
            
        case ActionBar:
            if (rgb) controlState = Both;
            break;
            
        case Both:
            if (!rgb) controlState = ActionBar;
            break;
            
        default:
            break;
    }
    int offSetX = 0;
    
    if (!rgb)
    {
        offSetX = GET_WIDTH(rgbInfo.frame);
        
    }

    [self layControls:offSetX andActionBar:-1];
}

- (void)showAction:(BOOL)action
{
    switch (controlState)
    {
        case None:
            if (action) controlState = ActionBar;
            break;
            
        case RGB:
            if (action) controlState = Both;
            break;
            
        case ActionBar:
            if (!action) controlState = None;
            break;
            
        case Both:
            if (!action) controlState = RGB;
            break;
            
        default:
            break;
    }
    int offSetX = iPHONE ? viewWidth : GET_WIDTH(actionBar.frame);
    
    if (action)
    {
        offSetX = iPHONE ? viewWidth - GET_WIDTH(actionBar.frame) : 0;
    }

    [self layControls:-1 andActionBar:offSetX];
}

- (void)layControls:(int)rgbOffSet andActionBar:(int)actionOffSet
{
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (rgbOffSet != -1)
                         {
                             self->rgbInfo.alpha = rgbOffSet == 0 ? 0.8 : 0.5;
                             self->rgbInfo.frame = SET_X(self->rgbInfo.frame, -rgbOffSet);
                         }
                         if (iPHONE && actionOffSet != -1)
                         {
                             self->actionBar.alpha = actionOffSet == viewWidth ? 0.5 : 0.8;
                             self->actionBar.frame = SET_X(self->actionBar.frame, actionOffSet);
                             
                         }
                         else if (iPAD && actionOffSet != -1)
                         {
                             self->actionBar.alpha = actionOffSet == 0 ? 0.8 : 0.5;
                             self->actionBar.frame = SET_X(self->actionBar.frame, -actionOffSet);
                         }

                         // change scroll view frame
        CGRect frame = self->scrollView.frame;
                         if (iPHONE)
                         {
                             frame = [self getScrollViewFrameiPhone:frame];
                         }
                         else
                         {
                             frame = [self getScrollViewFrameiPad:frame];
                         }
                         
        self->scrollView.frame = frame;
        CGFloat currentScale = self->imageView.frame.size.width / self->imageView.bounds.size.width;
        self->tappedPoint.center = CGPointMake(abPoint.x*currentScale , abPoint.y*currentScale);
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             CGFloat currentScale = self->imageView.frame.size.width / self->imageView.bounds.size.width;
                             self->tappedPoint.center = CGPointMake(abPoint.x*currentScale , abPoint.y*currentScale);
                         }
                         
                     }];
}
- (CGRect)getScrollViewFrameiPad:(CGRect)frame
{
    if (controlState != None)
    {
        frame.size.width = viewWidth - SIDE_BAR_WIDTH - MARGIN*2;
        frame.origin.x = SIDE_BAR_WIDTH + MARGIN;
    }
    else
    {
        frame.size.width = viewWidth-MARGIN*2;
        frame.origin.x = MARGIN;
    }
    
    if (GET_WIDTH(imageView.frame) < frame.size.width)
    {
        frame.size.width = GET_WIDTH(imageView.frame);
    }

    CGFloat diff = (frame.origin.x + frame.size.width) - (viewWidth - MARGIN);
    if (diff < 0)
    {
        frame.origin.x -= diff/2;
    }
    
    frame.origin.y = MARGIN;
    frame.size.height = viewHeight-MARGIN*2;
    if (GET_HEIGHT(imageView.frame) < frame.size.height)
    {
        frame.size.height = GET_HEIGHT(imageView.frame);
    }
   
    diff = viewHeight-MARGIN*2 - frame.size.height;
    if (diff > 0)
    {
        frame.origin.y += diff/2;
    }
    
    return frame;
}

- (CGRect)getScrollViewFrameiPhone:(CGRect)frame
{
    if (controlState != None)
    {
        frame.size.height = viewHeight-BOTTON_BAR_HEIGHT-StatusBar-MARGIN;
    }
    else
    {
        frame.size.height = viewHeight-StatusBar-MARGIN;
    }
    
    
    if (GET_HEIGHT(imageView.frame) < frame.size.height)
    {
        frame.size.height = GET_HEIGHT(imageView.frame);
    }
    if (frame.origin.y > StatusBar)
    {
        frame.origin.y = StatusBar;
        if (frame.size.height < viewHeight-BOTTON_BAR_HEIGHT-StatusBar-MARGIN)
        {
            if (controlState == None)
                frame.origin.y = (viewHeight-StatusBar-MARGIN-frame.size.height)/2 + StatusBar;
            else
                frame.origin.y = (viewHeight-BOTTON_BAR_HEIGHT-StatusBar-MARGIN-frame.size.height)/2 + StatusBar;
        }
        
    }
    else if (frame.size.height < viewHeight-StatusBar-MARGIN && controlState == None)
    {
        frame.origin.y = (viewHeight-frame.size.height)/2 - StatusBar;
    }
    return frame;
}

- (void)tapAction:(UITapGestureRecognizer*)sender
{
    CGPoint tapPoint = [sender locationInView:scrollView];
    
    CGFloat currentScale = imageView.frame.size.width / imageView.bounds.size.width;
    
    abPoint = CGPointMake(tapPoint.x/currentScale, tapPoint.y/currentScale);

    UIColor *selectedColor = [image colorAtPosition:abPoint];
    CGFloat red,green,blue,alpha;
    [selectedColor getRed:&red green:&green blue:&blue alpha:&alpha];
    

    [colorCodeBtn setTitle:[NSString stringWithFormat:@"R:%i G:%i B:%i",(int)(red*255), (int)(green*255), (int)(blue*255)] forState:UIControlStateNormal];
    
    NSString *color;
    if (OperationQueueManager.instance.opCount == 0)
        color = [ColorCodeController.instance getColorName:red*255 g:green*255 b:blue*255];
    else
        color = @"Local database is not ready yet";
    [colorNameBtn setTitle:color forState:UIControlStateNormal];
    
    [scrollView setBackgroundColor:selectedColor];
    [self.view setBackgroundColor:selectedColor];
    
    tappedPoint.hidden = false;
    tappedPoint.center = tapPoint;
    [tappedPoint removeFromSuperview];
    [scrollView addSubview:tappedPoint];
    

    
//    MagViewController *magViewController = [MagViewController new];
//    magViewController.providesPresentationContextTransitionStyle = true;
//    magViewController.definesPresentationContext = true;
//    magViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:magViewController animated:false completion:nil];
    //CGPoint tapPointInView = [scrollView convertPoint:tapPoint toView:self.view];
}

- (void)pinch:(UIPinchGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded
        || gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"gesture.scale = %f", gesture.scale);
        
        CGFloat currentScale = imageView.frame.size.width / imageView.bounds.size.width;
        NSLog(@"currentScale = %f", currentScale);
        CGFloat newScale = currentScale * gesture.scale;
         NSLog(@"newScale = %f", newScale);
        
        if (newScale < MINIMUM_SCALE) {
            newScale = MINIMUM_SCALE;
        }
        if (newScale > MAXIMUM_SCALE) {
            newScale = MAXIMUM_SCALE;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        if (iPHONE) {
            [self doTransform:transform];
        } else {
        [self doTransformIPAD:transform];
        }
        
        gesture.scale = 1;
        tappedPoint.center = CGPointMake(abPoint.x*newScale , abPoint.y*newScale);
    }
}

- (void)layoutMenu
{
    if (iPHONE)
    {
        rgbInfo.frame = SET_Y(rgbInfo.frame , viewHeight - BOTTON_BAR_HEIGHT);
        rgbInfo.frame = SET_X(rgbInfo.frame , -GET_WIDTH(rgbInfo.frame));
        actionBar.frame = SET_Y(actionBar.frame, viewHeight - BOTTON_BAR_HEIGHT);
        actionBar.frame = SET_X(actionBar.frame, viewWidth);
    }
    else
    {
//        rgbInfo.frame = SET_X(rgbInfo.frame , -GET_WIDTH(rgbInfo.frame));
//        actionBar.frame = SET_X(actionBar.frame , -GET_WIDTH(actionBar.frame));
    }
//    [UIView animateWithDuration:0.2f
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//        self->scrollView.alpha = 1;
//                     }
//                     completion:nil];
}

- (void)doTransform:(CGAffineTransform) transform
{
    CGFloat minHeight = controlState != None ? viewHeight - BOTTON_BAR_HEIGHT : viewHeight;
    imageView.transform = transform;
    scrollView.contentSize =  imageView.frame.size;
    CGRect frame = scrollView.frame;
    if (imageView.frame.size.height < minHeight - StatusBar - MARGIN)
    {
        frame.size.height =imageView.frame.size.height;
        frame.origin.y = (minHeight-frame.size.height)/2;
    }
    else
    {
        frame.size.height = minHeight - StatusBar - MARGIN;
        frame.origin.y = StatusBar;
        frame.size.width = minHeight;
    }
    
    if (imageView.frame.size.width < viewWidth-MARGIN*2)
    {
        frame.size.width = imageView.frame.size.width;
        frame.origin.x = (viewWidth-frame.size.width)/2;
    }
    else
    {
        
        frame.origin.x = MARGIN;
        frame.size.width = viewWidth - MARGIN *2;
    }
    
    scrollView.frame = frame;
    imageView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
}

- (void)doTransformIPAD:(CGAffineTransform) transform
{
    imageView.transform = transform;
    scrollView.contentSize =  imageView.frame.size;
    CGRect frame = scrollView.frame;
    frame = [self getScrollViewFrameiPad:frame];
    
    scrollView.frame = frame;
    imageView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
}

- (IBAction)albumPressed
{
    // check if the choosen image type source is avaiable
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:ipc animated:true completion:nil];
        [self showAction:true];
        [self showRGB:true];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unable to acces selected photo sources"
                                                       message:@"Photo Library is not available in this device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)cameraPressed
{
    // check if the choosen image type source is avaiable
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        if (iPAD) {
            ipc.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
        
        
        [self presentViewController:ipc animated:true completion:nil];
        [self showAction:false];
        [self showRGB:false];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unable to acces Camera"
                                                       message:@"Camera is not available in this device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark UIImagePickerDelegate Method - finished, and cancelled

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // reset imageView transform
    //scrollView.alpha = 0.5;
    [ipc dismissViewControllerAnimated:true completion:^{
        if (iPAD && picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
        {
            [self prepareView];
        }
    }];


}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // reset imageView transform
    imageView.transform = CGAffineTransformIdentity;
    //scrollView.alpha = 0;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.frame = frame;
    scrollView.contentSize = imageView.frame.size;
    imageView.image = image;
    //scrollView.frame = SET_HEIGHT(scrollView.frame, SCREEN_HEIGHT);
    //scrollView.frame = SET_WIDTH(scrollView.frame, SCREEN_WIDTH);
    [ipc dismissViewControllerAnimated:true completion:^{
        if (iPAD && picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
        {
            [self prepareView];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
