//
//  KKAutoScrollViewController.h
//  TSAutoScroll
//
//  Created by MR.KING on 16/3/27.
//  Copyright © 2016年 EBJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class KKAutoScrollViewController;

@protocol KKAutoScrollViewControllerDelegate <NSObject>

-(void)autoScrollView:(KKAutoScrollViewController*)controller didClickAtItem:(NSInteger)index;

@end

@interface KKAutoScrollViewController : NSObject

@property(nonatomic,strong)UIView * view;

@property(nonatomic,strong)UIImage * placeHolderImage;

@property(nonatomic,strong)NSArray * imageUrl;

@property(nonatomic,strong)NSArray * titles;

@property(nonatomic,assign)CGFloat animationDurtion;

@property(nonatomic,assign)BOOL showPageControl;

@property(nonatomic,strong)UIColor * pageControlSeletedColor;

@property(nonatomic,strong)UIColor * pageControlNormalColor;

@property(nonatomic,weak)id<KKAutoScrollViewControllerDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;


@end
