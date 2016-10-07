//
//  KKAutoCollectionViewCell.m
//  TSAutoScroll
//
//  Created by MR.KING on 16/3/27.
//  Copyright © 2016年 EBJ. All rights reserved.
//

#import "KKAutoCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface KKAutoCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation KKAutoCollectionViewCell

-(void)showDataWithImageUrl:(NSURL*)imageUrl placeHolderImage:(UIImage * )placeHolderImage title:(NSString*)title{
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:placeHolderImage];
    self.titleLable.text = title;
}



@end
