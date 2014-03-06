//
//  MemCircle.h
//  Memory
//
//  Created by Bryan Weber on 2/16/14.
//  Copyright (c) 2014 Bryan Weber. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MemCircle : SKShapeNode

@property (nonatomic) int positionBitMask;

-(id)initWithPosition:(int)position inSize:(CGSize)size;

@end
