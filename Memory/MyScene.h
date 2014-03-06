//
//  MyScene.h
//  Memory
//

//  Copyright (c) 2014 Bryan Weber. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property (nonatomic, strong) NSMutableArray *sequence;
@property (nonatomic) BOOL userTurn;
@property (nonatomic) int userSeqStep;
@property (nonatomic) BOOL gameOver;

@end
