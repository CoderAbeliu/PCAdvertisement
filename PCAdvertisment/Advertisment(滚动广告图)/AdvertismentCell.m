//
//  AdvertismentCell.m
//  Abe UI
//
//  Created by topfuture on 2017/10/23.
//  Copyright © 2017年 abe_liu. All rights reserved.
//

#import "AdvertismentCell.h"

@implementation AdvertismentCell

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.imageView=[[UIImageView alloc]initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
@end
