//
//  PlayingViewController.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController

//要播放第几首歌曲
@property (nonatomic, assign) NSInteger index;


+ (instancetype)sharedPlayingPVC;

@end
