//
//  ViewController.m
//  ImageSwiper
//
//  Created by Tim Woo on 9/21/13.
//  Copyright (c) 2013 Tim Woo. All rights reserved.
//

#import "ViewController.h"

#define DEGREE_TO_RADIAN(x) x*M_PI/180
#define NUM_PHOTOS 10
@interface ViewController () <UIGestureRecognizerDelegate>

@property (nonatomic) CGPoint originalPoint;
@property (nonatomic, retain) NSMutableArray *photos;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // bottom cards
    for (int i=0; i<2;i++) {
        UIView *backCard = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-100, self.view.center.y-150, 200, 300)];
        if (i==0) {
            backCard.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
            backCard.layer.shouldRasterize = YES;
            backCard.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIAN(3));
        }
        else if (i==1) {
            backCard.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
            backCard.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIAN(-2));
        }
        [self.view addSubview:backCard];
    }
    
    
    self.photos = [[NSMutableArray alloc] initWithCapacity:NUM_PHOTOS];
    for (int i=0; i<NUM_PHOTOS;i++) {
        UIView *photo = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-100, self.view.center.y-150, 200, 300)];
        photo.layer.backgroundColor = [self colorWithIdx:i].CGColor;
        photo.layer.shouldRasterize = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
        pan.delegate = self;
        [photo addGestureRecognizer:pan];

        [self.photos addObject:photo];
    }
    
    for (UIView *view in self.photos) {
        [self.view addSubview:view];
    }

    self.originalPoint = self.view.center;
}

- (UIColor *)colorWithIdx:(int)index {
    UIColor *color;
    switch (index%7) {
        case 0:
            color = [UIColor redColor];
            break;
        case 1:
            color = [UIColor yellowColor];
            break;
        case 2:
            color = [UIColor orangeColor];
            break;
        case 3:
            color = [UIColor blueColor];
            break;
        case 4:
            color = [UIColor magentaColor];
            break;
        case 5:
            color = [UIColor greenColor];
            break;
        case 6:
            color = [UIColor purpleColor];
            break;
        default:
            break;
    }
    return color;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (IBAction)panHandle:(UIPanGestureRecognizer *)gesture {
    CGPoint newLocation = [gesture locationInView:self.view];

    if(gesture.state==UIGestureRecognizerStateBegan) {
        CGPoint anchor = [gesture locationInView:gesture.view];
        gesture.view.layer.anchorPoint = CGPointMake(anchor.x/gesture.view.bounds.size.width,
                                                     anchor.y/gesture.view.bounds.size.height);
    }
    else if(gesture.state==UIGestureRecognizerStateChanged) {
        gesture.view.layer.position = newLocation;
        
        CGPoint velocity = [gesture velocityInView:gesture.view];
        if(velocity.x > self.view.bounds.size.width*0.15 || velocity.x < -self.view.bounds.size.width*0.15)
        {
            CGFloat rotation = -10*(-newLocation.x/160+1);
            gesture.view.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIAN(rotation));
        }
        
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"location X= %f Y=%f", newLocation.x, newLocation.y);

        CGPoint velocity = [gesture velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.0025 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(gesture.view.layer.position.x + (velocity.x * slideFactor),
                                         gesture.view.layer.position.y + (velocity.y * slideFactor));
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            gesture.view.layer.position = finalPoint;
        } completion:^(BOOL finished) {
            if (gesture.view.layer.position.x > 50 && gesture.view.layer.position.x < 270) {
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    gesture.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    gesture.view.transform = CGAffineTransformIdentity;
                    gesture.view.layer.position = self.originalPoint;
                } completion:nil];
            }
            else {
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGFloat offscreenX = (gesture.view.layer.position.x<270 ? -320 : 640);
                    gesture.view.layer.position = CGPointMake(offscreenX, gesture.view.layer.position.y);
                } completion:^(BOOL finished) {
                    // show new uiview
                    
                }];
            }
        }];
    }
}

- (void) applyRotationToView:(UIView*)rotationView byAngle:(CGFloat)angle {
    rotationView.transform = CGAffineTransformRotate(rotationView.transform, angle);
}

@end
