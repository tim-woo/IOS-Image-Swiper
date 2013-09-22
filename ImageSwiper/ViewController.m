//
//  ViewController.m
//  ImageSwiper
//
//  Created by Tim Woo on 9/21/13.
//  Copyright (c) 2013 Tim Woo. All rights reserved.
//

#import "ViewController.h"
#import "CardView.h"

#define DEGREE_TO_RADIAN(x) x*M_PI/180
#define NUM_PHOTOS 50
@interface ViewController ()

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
        UIView *bottomCard = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x-100, self.view.center.y-100, 200, 200)];
        if (i==0) {
            bottomCard.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
            bottomCard.layer.shouldRasterize = YES;
            bottomCard.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIAN(3));
        }
        else if (i==1) {
            bottomCard.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
            bottomCard.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIAN(-2));
        }
        [self.view addSubview:bottomCard];
    }
    
    
    self.photos = [[NSMutableArray alloc] initWithCapacity:NUM_PHOTOS];
    for (int i=0; i<NUM_PHOTOS;i++) {
        CardView *card = [[CardView alloc] initWithFrame:CGRectMake(self.view.center.x-140, self.view.center.y-140, 280, 280)];
        card.front.layer.backgroundColor = [self colorWithIdx:i].CGColor;
        card.back.layer.backgroundColor = card.front.layer.backgroundColor;
        
        [self.photos addObject:card];
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

@end
