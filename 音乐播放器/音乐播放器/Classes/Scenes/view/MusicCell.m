//
//  MusicCell.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "MusicCell.h"
#import "DataManager.h"

@interface MusicCell ()

@property (strong, nonatomic) IBOutlet UILabel *songLabel;

@property (strong, nonatomic) IBOutlet UILabel *singleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *ImgView;

@end


@implementation MusicCell

- (void)setMusicModel:(MusicModel *)musicModel{
//    值传过来 要接受，不然再次点击时  musicmodel是空；
    _musicModel = musicModel;
    _songLabel.text = musicModel.name;
    _singleLabel.text = musicModel.singer;
//    加载图片： 打个断点， 在展示框输入 po model.name 可以取到当前执行的具体数值。（LLDB）
    [_ImgView sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl]];
    
}

// 小黄鸭调试方法。




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
