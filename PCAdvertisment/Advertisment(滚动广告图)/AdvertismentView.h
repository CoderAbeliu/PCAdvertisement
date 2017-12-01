//
//  AdvertismentView.h
//  Abe UI
//
//
//  Created by topfuture on 2017/10/23.
//  Copyright © 2017年 abe_liu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef void(^ClickItemBlock)(NSInteger currentRow);
@interface AdvertismentView : UIView

@property(nonatomic,copy)ClickItemBlock clickBlock;


+(id)adCollectionViewFrame:(CGRect)frame modelArray:(NSArray *)modelArray pageControlShowStyle:(UIPageControlShowStyle)pageControlShowStyle;


@end
