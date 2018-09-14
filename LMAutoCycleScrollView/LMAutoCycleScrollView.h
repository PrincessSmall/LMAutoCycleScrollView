//
//  LMAutoCycleScrollView.h
//  LMAutoCycleScrollView
//
//  Created by 李敏 on 2018/8/16.
//  Copyright © 2018年 李敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMAutoCycleScrollView : UIView{
    
    
    BOOL isDirection;
    
}

/**
 设置轮播图片

 @param count 需要展示的图片个数
 */
-(void)setImageCount:(NSUInteger)count;

-(void)startNSTimer;

-(void)endNStimer;

@end
