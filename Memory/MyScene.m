//
//  MyScene.m
//  Memory
//
//  Created by Bryan Weber on 2/16/14.
//  Copyright (c) 2014 Bryan Weber. All rights reserved.
//

#import "MyScene.h"
#import "MemCircle.h"

@interface MyScene(Private)
-(void)continueSequence;
-(void)nextInSequence:(NSInteger)seqNum;
@end

@implementation MyScene

@synthesize sequence, userTurn, userSeqStep, gameOver;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        for (int i = 0; i < 9; i++) {
            
            MemCircle *button = [[MemCircle alloc] initWithPosition:i inSize:size];
            
            if(i < 3)
            {
                button.position = CGPointMake(((size.width)*.90*((i+1.0)/3.0)-button.frame.size.width/2),
                                              ((size.height*.80)/3)-button.frame.size.height/2);
            }
            else if (i < 6)
            {
                button.position = CGPointMake(((size.width)*.90*((i-2.0)/3.0)-button.frame.size.width/2),
                                              ((size.height*.80)*(2.0/3.0))-button.frame.size.height/2);
            }
            else
            {
                button.position = CGPointMake(((size.width)*.90*((i-5.0)/3.0)-button.frame.size.width/2),
                                              ((size.height*.80))-button.frame.size.height/2);
            }
            
            NSLog(@"Adding button at: (%f,%f)", button.position.x, button.position.y);
            
            [self addChild:button];
            
        }
        
        SKLabelNode *score = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
        [score setFontSize:self.frame.size.width*0.10];
        score.text = @"0";
        score.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.90);
        score.fontColor = [SKColor colorWithRed:0.23 green:0.56 blue:0.79 alpha:1.0];
        score.name = @"scoreLabel";
        [self addChild:score];
        
        sequence = [NSMutableArray array];
        userTurn = NO;
        userSeqStep = 0;
        gameOver = NO;
        
    }
    return self;
}

-(void) didMoveToView:(SKView *)view
{
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startBtn setTitle:@"Start!" forState:UIControlStateNormal];
    [startBtn setTitle:@"Start!" forState:UIControlStateSelected];
    [[startBtn titleLabel] setFont:[UIFont fontWithName:@"Marker Felt" size:[view frame].size.width*0.05]];
    [startBtn setFrame:CGRectMake([view frame].size.width*0.05, [view frame].size.height*0.05,
                                  [view frame].size.width*0.25, [view frame].size.height*0.10)];
    [startBtn addTarget:self action:@selector(startBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setBackgroundColor:[UIColor whiteColor]];
    [[startBtn titleLabel] setTextColor:[UIColor colorWithRed:0.23 green:0.56 blue:0.79 alpha:1.0]];
    
    
    [view insertSubview:startBtn atIndex:[[view subviews] count]];
    NSLog(@"Adding Button at (%f, %f)", startBtn.frame.origin.x, startBtn.frame.origin.y);
}

-(void)startBtnPress:(id)sender
{
    UIButton *startBtn = (UIButton*)sender;
    [startBtn removeFromSuperview];
    
    SKAction *wait = [SKAction waitForDuration:2.0];
    [self runAction:wait completion:^(void){
        [self continueSequence];
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        //CGPoint location = [touch locationInNode:self];
        NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
        for(SKNode *node in nodes)
        {
            if([node.name isEqualToString:@"button"])
            {
                MemCircle *touchedCircle = (MemCircle*)node;
                touchedCircle.glowWidth = touchedCircle.frame.size.width/4;
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    int touchesMask = 0;
    for (UITouch *touch in touches) {
        NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
        for(SKNode *node in nodes)
        {
            if([node.name isEqualToString:@"button"])
            {
                MemCircle *touchedCircle = (MemCircle*)node;
                touchedCircle.glowWidth = 0.0;
                touchesMask = touchesMask | touchedCircle.positionBitMask;
            }
        }
    }
    
    if(userTurn == YES && gameOver != YES)
    {
        if(userSeqStep < [sequence count])
        {
            NSNumber *nextNum = [sequence objectAtIndex:userSeqStep];
            int nextIntMask = [nextNum intValue];
            if(touchesMask != nextIntMask)
            {
                gameOver = YES;
                SKLabelNode *lose = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
                [lose setFontSize:self.frame.size.width*0.15];
                lose.text = @"You Lose!";
                lose.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
                lose.fontColor = [SKColor colorWithRed:0.23 green:0.56 blue:0.79 alpha:1.0];
                lose.name = @"loseLabel";
                [self addChild:lose];
                
                return;
            }
            if(userSeqStep == [sequence count] - 1)
            {
                //update the score
                SKLabelNode *scoreNode = (SKLabelNode*)[self childNodeWithName:@"scoreLabel"];
                [scoreNode setText:[NSString stringWithFormat:@"%i", [sequence count]]];
                
                //continue the sequence
                [self continueSequence];
            }
            else
            {
                userSeqStep++;
            }
        }
    }
    
    if(gameOver == YES)
    {
        NSLog(@"Restarting game...");
        
        SKNode *lose = [self childNodeWithName:@"loseLabel"];
        [lose removeFromParent];
        
        SKLabelNode *scoreNode = (SKLabelNode*)[self childNodeWithName:@"scoreLabel"];
        [scoreNode setText:@"0"];
        
        userTurn = NO;
        sequence = NULL;
        sequence = [NSMutableArray array];
        gameOver = NO;
        [self continueSequence];
    }
}

-(void)continueSequence
{
    userSeqStep = 0;
    userTurn = NO;
    int newSeq = arc4random_uniform(8) + 1;
    NSNumber *newSeqMask = [NSNumber numberWithInt:(1 << newSeq)];
    
    NSLog(@"Adding sequence mask %@", newSeqMask);
    
    [sequence addObject:newSeqMask];
    
    SKAction *wait = [SKAction waitForDuration:2.0];
    [self runAction:wait completion:^(void){
        [self nextInSequence:0];
    }];
    
}

-(void)nextInSequence:(NSInteger)seqNum
{
    if(seqNum < [sequence count])
    {
        NSNumber *nextNum = [sequence objectAtIndex:seqNum];
        int nextSeqMask = [nextNum intValue];
        for(SKNode *node in self.children)
        {
            if([node.name isEqualToString:@"button"])
            {
                MemCircle *button = (MemCircle*)node;
                if((button.positionBitMask & nextSeqMask) != 0)
                {
                    SKAction *grow = [SKAction customActionWithDuration:0.5 actionBlock:^(SKNode *node, CGFloat elapsedTime){
                        button.glowWidth = button.frame.size.width/4;
                    }];
                    SKAction *shrink = [SKAction customActionWithDuration:0.5 actionBlock:^(SKNode *node, CGFloat elapsedTime){
                        button.glowWidth = 0;
                    }];
                    
                    SKAction *growshrink = [SKAction sequence:@[grow, shrink]];
                    
                    [button runAction:growshrink completion:^(void){
                        [self nextInSequence:(seqNum + 1)];
                    }];
                }
            }
        }
    }
    else
    {
        userTurn = YES;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
