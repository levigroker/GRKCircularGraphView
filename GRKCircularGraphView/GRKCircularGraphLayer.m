//
//  GRKCircularGraphLayer.m
//
//  Created by Levi Brown on August 6, 2014.
//  Copyright (c) 2014-2017 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import "GRKCircularGraphLayer.h"

static NSTimeInterval const kGRKDefaultAnimationDuration = 0.0f;
static CGFloat const kDefaultIndicatorThickness = 10.0f;

@interface GRKCircularGraphLayer () <CALayerDelegate>
@end


@implementation GRKCircularGraphLayer

@dynamic percent, color, indicatorThickness, startAngle, clockwise;

#pragma mark - Class Level

+ (NSSet *)animationKeys
{
    static NSSet *keys = nil;
    if (!keys)
    {
        keys = [NSSet setWithObjects:@"percent", nil];
    }
    
    return keys;
}

+ (NSSet *)displayKeys
{
    static NSSet *keys = nil;
    if (!keys)
    {
        keys = [NSSet setWithObjects:@"color", @"indicatorThickness", @"startAngle", @"clockwise", @"bounds", nil];
    }
    
    return keys;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([[self animationKeys] containsObject:key] || [[self displayKeys] containsObject:key])
    {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        [self setup];
        
        //Copy custom property values into our new instance from the given layer.
        //We need to do this or layers created in the animation process will not get our custom property values.
        GRKCircularGraphLayer *baseLayer = (GRKCircularGraphLayer *)layer;
        self.animationDuration = baseLayer.animationDuration;
        self.mediaTimingFunction = baseLayer.mediaTimingFunction;
        self.percent = baseLayer.percent;
        self.color = baseLayer.color;
        self.indicatorThickness = baseLayer.indicatorThickness;
        self.startAngle = baseLayer.startAngle;
        self.clockwise = baseLayer.clockwise;
    }
    return self;
}

- (void)setup
{
    //Set ourself as our delegate so we can prevent implicit animations of properties we don't want to animate.
    self.delegate = (id<CALayerDelegate>)self;
    //Defaults
    self.mediaTimingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    self.animationDuration = kGRKDefaultAnimationDuration;
    self.indicatorThickness = kDefaultIndicatorThickness;
    self.startAngle = M_PI_2 * 3.0f;
    self.clockwise = YES;
}

#pragma mark - CALayer Delegate

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    id<CAAction> retVal = nil;
    
    if (![layer isEqual:self] || ![[self animationKeys] containsObject:event])
    {
        retVal = (id<CAAction>)[NSNull null]; // disable all implicit animations
    }
    
    return  retVal;
}

#pragma mark - Animation

- (id<CAAction>)actionForKey:(NSString *)event
{
    id<CAAction> retVal = [self animationForKey:event];
    if (!retVal)
    {
        retVal = [super actionForKey:event];
    }
    
    return retVal;
}

- (CABasicAnimation *)animationForKey:(NSString *)key
{
    CABasicAnimation *retVal = nil;
    
    if (self.animationDuration > 0.0f && [[self.class animationKeys] containsObject:key])
    {
        retVal = [CABasicAnimation animationWithKeyPath:key];
        retVal.fromValue = [[self presentationLayer] valueForKey:key];
        retVal.timingFunction = self.mediaTimingFunction;
        retVal.duration = self.animationDuration;
    }
    
	return retVal;
}

#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)context
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
    //The shape radius (minimum of center.x and center.y so we will not draw out of bounds)
    CGFloat radius = MIN(center.y, center.x);

    CGContextSetLineWidth(context, self.indicatorThickness);
    
    //Adjust the radius for the line width
    radius -= self.indicatorThickness / 2.0f;
    
    static CGFloat maxAngle = 2.0f * M_PI;

    //On iOS the y axis grows larger going toward the bottom, which causes the arc to be drawn in the opposite direction than we specify in `CGContextAddArc`, so we have to flip things over here and in our call to `CGContextAddArc`...
    CGFloat arcAngle = maxAngle * self.percent;
    if (!self.clockwise)
    {
        arcAngle = -arcAngle;
    }
    CGFloat endAngle = self.startAngle + arcAngle;
    
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, self.startAngle, endAngle, self.clockwise ? 0 : 1 /* Flip to accomodate the inverted y coordinate space */);
    
    CGContextSetStrokeColorWithColor(context, self.color);
    CGContextStrokePath(context);
}

@end
