//
//  USEquipmentListView.m
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USEquipmentListView.h"
#import "EquipmentView.h"

#define ORIGIN_X [UIScreen mainScreen].bounds.size.width - 20.0
#define ORIGIN_Y 0.0

#define LIST_WIDTH 140.0
#define LIST_HEIGHT [UIScreen mainScreen].bounds.size.height

#define MOVED_ORIGIN_X [UIScreen mainScreen].bounds.size.width - LIST_WIDTH

#define EQUIPMENT_WIDTH 120.0
#define EQUIPMENT_HEIGHT 120.0

#define SLIDE_TIMING .25

@interface USEquipmentListView ()
@property (nonatomic) BOOL isHide;
@property (nonatomic) BOOL showingList;
@property (nonatomic) BOOL showList;
@property (nonatomic) BOOL hideList;
@property (nonatomic) CGPoint preVelocity;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation USEquipmentListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.3;
        /*
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];

        self.gestureRecognizers = @[panRecognizer];
        */
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, ORIGIN_Y, LIST_WIDTH, LIST_HEIGHT)];
        [self addSubview:self.scrollView];
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        self.gestureRecognizers = @[leftSwipe,rightSwipe];
        
        self.isHide = YES;
        self.showingList = NO;
    }
    return self;
}

- (id)init {
    self = [self initWithFrame:CGRectMake(ORIGIN_X, ORIGIN_Y, LIST_WIDTH+10.0, LIST_HEIGHT)];
    [self setupList];
    return self;
}

- (void)setupList {
    NSArray *equipments = [EquipmentView equipmentsButtonImages];
    double originy = 73.0;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, EQUIPMENT_HEIGHT * equipments.count);
    int i = 0;
    for (NSString *imageName in equipments) {
        UIControl *btn = [[UIControl alloc] initWithFrame:CGRectMake(20.0, originy, EQUIPMENT_WIDTH, EQUIPMENT_HEIGHT)];
        //falta la imagen
        btn.backgroundColor = [UIColor blueColor];
        btn.tag = i;
        
        [btn addTarget:self action:@selector(choseEquipment:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:btn];
        originy += EQUIPMENT_HEIGHT + 8.0;
        i++;
    }
}

- (void)choseEquipment:(UIControl *)button {
    [self.listDelegate equipmentList:self addEquipment:button.tag];
}

#pragma mark - Swipe Gesture

- (void)leftSwipe:(UISwipeGestureRecognizer *)leftSwipe {
    [self movePanelLeft];
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)leftSwipe {
    [self movePanelRight];
}

/*
-(void)movePanel:(id)sender
{
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        if(velocity.x > 0) {
            if (!self.isHide) {
                //esconder el panel
                self.showingList = NO;
            }
        } else {
            if (self.isHide) {
                //mostrar el panel
                self.showingList = YES;
            }
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if (!self.showList) {
            [self movePanelRight];
        } else if (self.hideList && !self.isHide) {
            [self movePanelLeft];
        } else {
            if (self.showingList) {
                [self movePanelLeft];
            } else {
                [self movePanelRight];
            }
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {

        // Are you more than halfway? If so, show the panel when done dragging by setting this value to YES (1).
        if (velocity.x < 0) {
            self.showList = abs([sender view].center.x - LIST_WIDTH/2) > LIST_WIDTH/2;
        } else {
            self.hideList = abs([sender view].center.x - LIST_WIDTH/2) < LIST_WIDTH/2;
        }
        
        
        // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
        //NSLog(@"x: %g || %g || %g",self.frame.origin.x, MOVED_ORIGIN_X, ORIGIN_X);
        CGFloat newOriginX = self.frame.origin.x + translatedPoint.x;
        if (newOriginX >= MOVED_ORIGIN_X && newOriginX <= ORIGIN_X) {
            self.center = CGPointMake(self.center.x + translatedPoint.x, self.center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self];
        }
        
        // If you needed to check for a change in direction, you could use this code to do so.
        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
            // NSLog(@"same direction");
        } else {
            // NSLog(@"opposite direction");
        }
        
        _preVelocity = velocity;
    }
}
*/
- (void)movePanelLeft // to show right panel
{
    self.isHide = NO;
    self.showingList = NO;
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.frame = CGRectMake(MOVED_ORIGIN_X, ORIGIN_Y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)movePanelRight // to show left panel
{
    self.isHide = YES;
    self.showingList = NO;
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.frame = CGRectMake(ORIGIN_X, ORIGIN_Y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
