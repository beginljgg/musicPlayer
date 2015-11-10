//
//  LyricManager.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"

@interface LyricManager ()
// 用来存放歌词
@property (nonatomic, strong) NSMutableArray * lyrics;

@end

@implementation LyricManager

static LyricManager * manager = nil;

+ (instancetype)sharedManager{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LyricManager new];
    });
    return manager;
}

- (void)loadLyricWith:(NSString *)lyricStr{
    
//    1.分行
    NSArray * lyricStringArray = [lyricStr componentsSeparatedByString:@"\n"];
    
//    要先将之前的歌词移除
    [self.lyrics removeAllObjects];
    
    //        NSArray * lyricStringArray = [[lyricStr componentsSeparatedByString:@"\n"] mutableCopy];
    //    删除最后一行。
    //        [lyricStringArray removeLastObject];
    
    
    
    for (NSString * str in lyricStringArray) {
//        判断一下  然后跳出循环 break也可以
        if ([str isEqualToString:@""]) {
            continue;
        }
      
//     2.   分开时间和歌词 （以 】分开）[00:10.440]It's been a long day without you my friend
        NSArray * timeAndLyric = [str componentsSeparatedByString:@"]"];
        
//        3.去掉时间左边的“【 ”；  substringFromIndex截取第一个元素到最后的字符串（删除下标为0的）
        NSString * time = [timeAndLyric[0] substringFromIndex:1];
        
//        time = 00:10.440
//        4.截取时间获得分和秒
        NSArray * minuteAndSecond = [time componentsSeparatedByString:@":"];
//        分
        NSInteger minute = [minuteAndSecond[0] integerValue];
//        秒
        double second = [minuteAndSecond[1] doubleValue];
//        5.装成一个model
        LyricModel * model = [[LyricModel alloc] initWithTime:(minute * 60 + second) lyric:timeAndLyric[1]];
//        6.添加到数组中
        [self.lyrics addObject:model];
//        注意跟上一句的区别
//        self.lyrics addObjectsFromArray:<#(nonnull NSArray *)#>
        
    }
    
}

- (NSInteger)indexWith:(NSTimeInterval)time{
    
    NSInteger index = 0;
//   遍历数组，找到还没有播放的那一句歌词。
    for (int i = 0; i < self.lyrics.count; i ++) {
        
        LyricModel * model = self.lyrics[i];
        
        if (model.time > time) {
//         注意 如果是第0个元素，而且元素的时间比要播放的时间大， i-1 就会小于0.这样tableView就是crash。
           index = (i - 1 > 0)?i - 1 : 0;
//            一定要break ， 要不就会一直循环下去。直接跳到最大值，也就是歌词的结尾。
            break;
        }
    }
    return index;
}



//  l懒加载 lazyLoad
- (NSMutableArray *)lyrics{
    
    if (!_lyrics) {
        _lyrics = [NSMutableArray new];
    }
    return _lyrics;
}

- (NSArray *)allLyric{
    
    return self.lyrics;
    
}





@end
