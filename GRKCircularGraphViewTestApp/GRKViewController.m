//
//  GRKViewController.m
//  GRKCircularGraphViewTestAppTests
//
//  Created by Levi Brown on 8/6/14.
//  Copyright (c) 2014 Levi Brown. All rights reserved.
//

#import "GRKViewController.h"
#import "GRKCircularGraphView.h"

@interface GRKViewController () <UITextFieldDelegate>

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
@property (nonatomic,weak) IBOutlet UIButton *clearColorButton;
@property (nonatomic,weak) IBOutlet UIButton *redColorButton;
@property (nonatomic,weak) IBOutlet UIButton *orangeColorButton;
@property (nonatomic,weak) IBOutlet UIButton *yellowColorButton;
@property (nonatomic,weak) IBOutlet UIButton *greenColorButton;
@property (nonatomic,weak) IBOutlet UIButton *blueColorButton;
@property (nonatomic,weak) IBOutlet UIButton *purpleColorButton;
@property (nonatomic,weak) IBOutlet UISegmentedControl *colorSegmentedControl;
@property (nonatomic,weak) IBOutlet UITextField *borderOffsetTextField;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic,strong) UIView *colorSelectionView;

- (IBAction)startAngleSliderValueChanged:(UISlider *)sender;
- (IBAction)widthSliderValueChanged:(UISlider *)sender;
- (IBAction)heightSliderValueChanged:(UISlider *)sender;
- (IBAction)percentSliderValueChanged:(UISlider *)sender;
- (IBAction)clockwiseSwitchValueChanged:(UISwitch *)sender;
- (IBAction)animateSwitchValueChanged:(UISwitch *)sender;
- (IBAction)useTinitColorSwitchValueChanged:(UISwitch *)sender;
- (IBAction)colorAction:(UIButton *)sender;
- (IBAction)colorSegmentedContrtolValueChanged:(UISegmentedControl *)sender;
- (IBAction)backgroundTapAction:(id)sender;

@end

@implementation GRKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Rotate our height slider
    UISlider *heightSlider = self.heightSlider;
    [heightSlider removeFromSuperview];
    [heightSlider removeConstraints:self.view.constraints];
    heightSlider.translatesAutoresizingMaskIntoConstraints = YES;
    heightSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.view addSubview:heightSlider];

    //Setup the selection view
    self.colorSelectionView = [[UIView alloc] init];
    self.colorSelectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.colorSelectionView.backgroundColor = [UIColor blackColor];
    UIView *subview = [[UIView alloc] init];
    subview.backgroundColor = self.view.backgroundColor;
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.colorSelectionView addSubview:subview];
    [self.colorSelectionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[subview]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subview)]];
    [self.colorSelectionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[subview]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(subview)]];
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
    [self updateSelectedColor];
    [self updateBorderOffset];
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
    self.graphView.indicatorColorUsesTintColor = sender.on;
    [self updateSelectedColor];
}

- (IBAction)colorAction:(UIButton *)sender;
{
    UIColor *color = sender.tag == 1 ? [UIColor clearColor] : sender.backgroundColor;

    switch (self.colorSegmentedControl.selectedSegmentIndex) {
        case 0: //Tint Color
            self.graphView.tintColor = color;
            break;
        case 1: //Bar Color
            self.graphView.indicatorColor = color;
            [self.tintColorSwitch setOn:NO animated:YES];
            [self useTinitColorSwitchValueChanged:self.tintColorSwitch];
            break;
        default: //Fill Color
            self.graphView.fillColor = color;
            break;
    }

    [self updateSelectedColor];
}

- (IBAction)colorSegmentedContrtolValueChanged:(UISegmentedControl *)sender
{
    [self updateSelectedColor];
}

- (IBAction)backgroundTapAction:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateBorderOffset];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Helpers

- (void)updateSelectedColor
{
    UIView *view = nil;
    switch (self.colorSegmentedControl.selectedSegmentIndex) {
        case 0: //Tint Color
            view = [self viewForColor:self.graphView.tintColor];
            break;
        case 1: //Bar Color
            view = [self viewForColor:self.graphView.indicatorColor];
            break;
        default: //Fill Color
            view = [self viewForColor:self.graphView.fillColor];
            break;
    }
    [self selectView:view];
}

- (UIView *)viewForColor:(UIColor *)color
{
    UIView *retVal = nil;
    
    if (!color || [color isEqual:[UIColor clearColor]])
    {
        retVal = self.clearColorButton;
    }
    else
    {
        NSArray *views = @[self.redColorButton, self.orangeColorButton, self.yellowColorButton, self.greenColorButton, self.blueColorButton, self.purpleColorButton];
        for (UIView *view in views)
        {
            if ([view.backgroundColor isEqual:color])
            {
                retVal = view;
                break;
            }
        }
        
        if (!retVal)
        {
            retVal = self.defaultColorButton;
        }
    }
    
    return retVal;
}

- (void)selectView:(UIView *)view
{
    [self.colorSelectionView removeFromSuperview];
    [self.view insertSubview:self.colorSelectionView belowSubview:self.defaultColorButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.colorSelectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:2.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.colorSelectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:2.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.colorSelectionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.colorSelectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];

}

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

- (void)updateBorderOffset
{
    NSString *text = self.borderOffsetTextField.text;
    CGFloat offset = [text floatValue];
    self.graphView.borderOffset = offset;
    self.borderOffsetTextField.text = [NSString stringWithFormat:@"%.1f", offset];
}

@end
