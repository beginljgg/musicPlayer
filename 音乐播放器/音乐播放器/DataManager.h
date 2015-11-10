//
//  DataManager.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
// 声明block 方法，用于刷新 （）
typedef void(^UpdataUI)();

@interface DataManager : NSObject
// block声明
@property (nonatomic, copy) UpdataUI myUpdataUI;
//@property (nonatomic, strong) NSArray * allmusic;
@property (nonatomic, retain) NSMutableArray * musicArray;

/**
 *  单例方法e  
 *
 *  @return 单例
 */
+ (DataManager *)sharedManager;

// command * control + ⬆️、⬇️ 切换.h.m

// 根据cell的索引返回一个model
- (MusicModel *)musicModelWithIndex:(NSInteger)index;

@end
