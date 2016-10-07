//
//  KKAutoPageControl.m
//  TSAutoScroll
//
//  Created by MR.KING on 16/3/27.
//  Copyright © 2016年 EBJ. All rights reserved.
//

#import "KKAutoPageControl.h"

@implementation KKAutoPageControl

-(void)setNumberOfPages:(NSInteger)numberOfPages{
    CGPoint center = self.center;
    [super setNumberOfPages:numberOfPages];
    self.center = center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
