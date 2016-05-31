//
//  GRKCircularGraphView.m
//
//  Created by Levi Brown on August 6, 2014.
//  Copyright (c) 2014 Levi Brown <mailto:levigroker@gmail.com>
//  This work is licensed under the Creative Commons Attribution 3.0
//  Unported License. To view a copy of this license, visit
//  http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
//  Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
//  USA.
//
//  The above attribution and the included license must accompany any version
//  of the source code. Visible attribution in any binary distributable
//  including this work (or derivatives) is not required, but would be
//  appreciated.
//

#import "GRKCircularGraphView.h"
#import "GRKCircularGraphBackingLayer.h"
#import "GRKCircularGraphLayer.h"

@interface GRKCircularGraphView ()

@property (nonatomic,strong) GRKCircularGraphBackingLayer *backingLayer;
@property (nonatomic,strong) GRKCircularGraphLayer *graphLayer;

@end

@implementation GRKCircularGraphView

#pragma mark - Class Level

+ (Class)layerClass
{
    return GRKCircularGraphBackingLayer.class;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //Here we have a custom layer backing this view, in which we draw the static parts of our graph, such as the border.
    //We have a custom sublayer, GRKCircularGraphLayer, which is used to render the animatable parts of the graph independently.
    //This optimizes the drawing when animating.
    //The backing layer is configured to layout its subviews with the same dimensions as itself, so we need not specify the frame of the sublayer here.
    
    self.backingLayer = (GRKCircularGraphBackingLayer *)[self layer];
    self.backingLayer.contentsScale = [UIScreen mainScreen].scale;
    
    self.graphLayer = [[GRKCircularGraphLayer alloc] init];
    self.graphLayer.contentsScale = [UIScreen mainScreen].scale;
    //Insert our graph layer below any other layers which may have been added (i.e. by a subview)
    [self.layer insertSublayer:self.graphLayer atIndex:0];

    //Setup our defaults
    self.indicatorColorUsesTintColor = YES;
    self.backingLayer.color = self.tintColor.CGColor;
    self.indicatorColor = self.tintColor;
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - Accessors

- (void)setMediaTimingFunction:(CAMediaTimingFunction *)mediaTimingFunction
{
    self.graphLayer.mediaTimingFunction = mediaTimingFunction;
}

- (CAMediaTimingFunction *)mediaTimingFunction
{
    return self.graphLayer.mediaTimingFunction;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    self.graphLayer.animationDuration = animationDuration;
}

- (NSTimeInterval)animationDuration
{
    return self.graphLayer.animationDuration;
}

- (UIColor *)indicatorColor
{
    return [UIColor colorWithCGColor:self.graphLayer.color];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    self.graphLayer.color = [indicatorColor CGColor];
}

- (CGFloat)percent
{
    return self.graphLayer.percent;
}

- (void)setPercent:(CGFloat)percent
{
    //Sanitize input
    percent = MAX(0.0f, MIN(1.0f, percent));
    
    self.graphLayer.percent = percent;
}

- (void)setIndicatorColorUsesTintColor:(BOOL)indicatorColorUsesTintColor
{
    _indicatorColorUsesTintColor = indicatorColorUsesTintColor;
    if (indicatorColorUsesTintColor)
    {
        self.indicatorColor = self.tintColor;
    }
}

- (CGFloat)indicatorThickness
{
   return self.graphLayer.indicatorThickness;
}

- (void)setIndicatorThickness:(CGFloat)indicatorThickness
{
    self.graphLayer.indicatorThickness = indicatorThickness;
}

- (CGFloat)borderThickness
{
    return self.backingLayer.borderThickness;
}

- (void)setBorderThickness:(CGFloat)borderThickness
{
    self.backingLayer.borderThickness = borderThickness;
}

- (CGFloat)borderOffset
{
	return self.backingLayer.borderOffset;
}

- (void)setBorderOffset:(CGFloat)borderOffset
{
	self.backingLayer.borderOffset = borderOffset;
}

- (UIColor *)fillColor
{
    return [UIColor colorWithCGColor:self.backingLayer.fillColor];
}

- (void)setFillColor:(UIColor *)fillColor
{
    self.backingLayer.fillColor = [fillColor CGColor];
}

- (CGFloat)startAngle
{
    return self.graphLayer.startAngle;
}

- (void)setStartAngle:(CGFloat)startAngle
{
    self.graphLayer.startAngle = startAngle;
}

- (BOOL)clockwise
{
    return self.graphLayer.clockwise;
}

- (void)setClockwise:(BOOL)clockwise
{
    self.graphLayer.clockwise = clockwise;
}

#pragma mark - Implementation

- (void)stopAnimation
{
    [self.graphLayer removeAnimationForKey:@"percent"];
}

#pragma mark - Overrides

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    
    self.backingLayer.color = self.tintColor.CGColor;
    if (self.indicatorColorUsesTintColor)
    {
        self.indicatorColor = self.tintColor;
    }
}

@end
