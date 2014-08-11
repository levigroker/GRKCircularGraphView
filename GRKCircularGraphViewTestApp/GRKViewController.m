//
//  GRKViewController.m
//  GRKCircularGraphViewTestAppTests
//
//  Created by Levi Brown on 8/6/14.
//  Copyright (c) 2014 Levi Brown. All rights reserved.
//

#import "GRKViewController.h"
#import "GRKCircularGraphView.h"

@interface GRKViewController ()

@property (nonatomic,weak) IBOutlet GRKCircularGraphView *graphView;

@property (nonatomic,weak) IBOutlet UISlider *startAngleSlider;
@property (nonatomic,weak) IBOutlet UISlider *widthSlider;
@property (nonatomic,weak) IBOutlet UISlider *heightSlider;
@property (nonatomic,weak) IBOutlet UISlider *percentSlider;
@property (nonatomic,weak) IBOutlet UISwitch *clockwiseSwitch;
@property (nonatomic,weak) IBOutlet UISwitch *animateSwitch;
@property (nonatomic,weak) IBOutlet UISwitch *tintColorSwitch;
@property (nonatomic,weak) IBOutlet UILabel *startAngleLabel;
@property (nonatomic,weak) IBOutlet UILabel *percentLabel;
@property (nonatomic,weak) IBOutlet UILabel *dimensionsLabel;
@property (nonatomic,weak) IBOutlet UIButton *defaultColorButton;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic,strong) UIView *tintColorSelectionView;
@property (nonatomic,strong) UIView *fillColorSelectionView;

- (IBAction)startAngleSliderValueChanged:(UISlider *)sender;
- (IBAction)widthSliderValueChanged:(UISlider *)sender;
- (IBAction)heightSliderValueChanged:(UISlider *)sender;
- (IBAction)percentSliderValueChanged:(UISlider *)sender;
- (IBAction)clockwiseSwitchValueChanged:(UISwitch *)sender;
- (IBAction)animateSwitchValueChanged:(UISwitch *)sender;
- (IBAction)useTinitColorSwitchValueChanged:(UISwitch *)sender;
- (IBAction)tintColorAction:(UIButton *)sender;
- (IBAction)fillColorAction:(UIButton *)sender;

@end

@implementation GRKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISlider *heightSlider = self.heightSlider;
    [heightSlider removeFromSuperview];
    [heightSlider removeConstraints:self.view.constraints];
    heightSlider.translatesAutoresizingMaskIntoConstraints = YES;
    heightSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.view addSubview:heightSlider];
    [self colorAction:YES sender:self.defaultColorButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.graphView.startAngle = self.startAngleSlider.value;
    self.graphView.percent = self.percentSlider.value;
    self.graphView.clockwise = self.clockwiseSwitch.on;
    self.percentSlider.continuous = !self.animateSwitch.on;
    [self updateStartAngleLabel];
    [self updatePercentLabel];
    [self widthSliderValueChanged:self.widthSlider];
    [self heightSliderValueChanged:self.heightSlider];
}

#pragma mark - Actions

- (IBAction)startAngleSliderValueChanged:(UISlider *)sender
{
    self.graphView.startAngle = sender.value;
    [self updateStartAngleLabel];
}

- (IBAction)widthSliderValueChanged:(UISlider *)sender
{
    CGFloat value = roundf(sender.value);
    self.widthConstraint.constant = value;
    [self updateViewConstraints];
    [self updateDimensionsLabel];
}

- (IBAction)heightSliderValueChanged:(UISlider *)sender
{
    CGFloat value = roundf(sender.value);
    self.heightConstraint.constant = value;
    [self updateViewConstraints];
    [self updateDimensionsLabel];
}

- (IBAction)percentSliderValueChanged:(UISlider *)sender
{
    NSTimeInterval duration = self.animateSwitch.on ? 0.5f : 0.0f;
    
    self.graphView.animationDuration = duration;
    self.graphView.percent = sender.value;
    [self updatePercentLabel];
}

- (IBAction)clockwiseSwitchValueChanged:(UISwitch *)sender
{
    self.graphView.clockwise = sender.on;
}

- (IBAction)animateSwitchValueChanged:(UISwitch *)sender
{
    self.percentSlider.continuous = !sender.on;
}

- (IBAction)useTinitColorSwitchValueChanged:(UISwitch *)sender
{
    if (sender.on)
    {
        [self.fillColorSelectionView removeFromSuperview];
        self.fillColorSelectionView = nil;
    }

    self.graphView.indicatorColorUsesTintColor = sender.on;
}

- (IBAction)tintColorAction:(UIButton *)sender
{
    [self colorAction:YES sender:sender];
}

- (IBAction)fillColorAction:(UIButton *)sender
{
    [self colorAction:NO sender:sender];
}

- (void)colorAction:(BOOL)tint sender:(UIButton *)sender
{
    UIView *view = tint ? self.tintColorSelectionView : self.fillColorSelectionView;
    UIColor *color = sender.tag == 1 ? [UIColor clearColor] : sender.backgroundColor;
    
    [view removeFromSuperview];
    view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:view belowSubview:sender];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeHeight multiplier:1.0f constant:2.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeWidth multiplier:1.0f constant:2.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:sender attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    UIView *subview = [[UIView alloc] init];
    subview.backgroundColor = self.view.backgroundColor;
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:subview];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[subview]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subview)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[subview]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subview)]];

    if (tint)
    {
        self.tintColorSelectionView = view;
        self.graphView.tintColor = color;
        if (self.graphView.indicatorColorUsesTintColor)
        {
            [self.fillColorSelectionView removeFromSuperview];
            self.fillColorSelectionView = nil;
        }
    }
    else
    {
        self.fillColorSelectionView = view;
        self.graphView.indicatorColor = color;
        [self.tintColorSwitch setOn:NO animated:YES];
        [self useTinitColorSwitchValueChanged:self.tintColorSwitch];
    }
}

#pragma mark - Helpers

- (void)updateStartAngleLabel
{
    self.startAngleLabel.text = [NSString stringWithFormat:@"%.2f", self.graphView.startAngle];
}

- (void)updatePercentLabel
{
    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", self.percentSlider.value * 100.0f];
}

- (void)updateDimensionsLabel
{
    self.dimensionsLabel.text = [NSString stringWithFormat:@"%.1f x %.1f", self.widthConstraint.constant, self.heightConstraint.constant];
}

@end
