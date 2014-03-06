//
//  MemCircle.m
//  Memory
//
//  Created by Bryan Weber on 2/16/14.
//  Copyright (c) 2014 Bryan Weber. All rights reserved.
//

#import "MemCircle.h"

@implementation MemCircle

@synthesize positionBitMask;

-(id)initWithPosition:(int)position inSize:(CGSize)size
{
    if((self = [super init]))
    {
        float red = (arc4random_uniform(60) + 40)/100.0;
        float green = (arc4random_uniform(60) + 40)/100.0;
        float blue = (arc4random_uniform(60) + 40)/100.0;
        CGMutablePathRef newPath = CGPathCreateMutable();
        CGPathAddArc(newPath, NULL, 0, 0, size.width*0.10, 0, M_PI*2, YES);
        self.path = newPath;
        self.lineWidth = 0.05;
        self.fillColor = [SKColor colorWithRed:red green:green blue:blue alpha:1.0];
        self.strokeColor = [SKColor colorWithRed:red green:green blue:blue alpha:1.0];
        self.glowWidth = 0.0;
        
        self.name = @"button";
        self.positionBitMask = 1 << position;
    }
    
    return self;
}

@end
