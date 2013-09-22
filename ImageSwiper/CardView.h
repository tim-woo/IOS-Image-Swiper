//
//  CardView.h
//
//  Created by Tim Woo on 9/22/13.
//  Copyright (c) 2013 Tim Woo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CardViewTopLeft = 0,
    CardViewTopRight = 1,
    CardViewBottomLeft = 2,
    CardViewBottomRight = 3
} CardViewLocation;

@class CardView;

@protocol CardViewDelegate <NSObject>

- (void)cardView:(CardView *)cardView willReturnToCenterFrom:(CardViewLocation)location;
- (void)cardView:(CardView *)cardView didReturnToCenterFrom:(CardViewLocation)location;
- (void)cardView:(CardView *)cardView willGoOffscreenFrom:(CardViewLocation)location;
- (void)cardView:(CardView *)cardView didGoOffscreenFrom:(CardViewLocation)location;

@end

@interface CardView : UIView

- (void)returnCardViewToStartPointAnimated:(BOOL)animated;

// Views
@property (strong, nonatomic) UIView *front;    // Add subviews to the front UIView to customize front of card
@property (strong, nonatomic) UIView *back;     // Add subviews to the back UIView to customize back of card
@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UILabel *label;

// Attributes
@property (assign, nonatomic) NSInteger stackIndex;   // Update if card is being placed in a stack to keep track of cards
@property (assign, nonatomic) NSInteger neededSwipeDistance;  // This is the distance a card must be swiped to fly off screen
@property (readonly, nonatomic) BOOL isOffScreen;
@property (readonly, nonatomic) BOOL isShowingFront;
@property (assign, nonatomic) CGFloat rotationAngle;
// Delegates
@property (assign, nonatomic) id<CardViewDelegate> delegate;

@end
