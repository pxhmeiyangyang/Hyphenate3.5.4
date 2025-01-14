/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseRecordView.h"
#import "EMCDDeviceManager.h"
#import "EaseLocalDefine.h"
#import "EaseSDKHelper.h"
@interface EaseRecordView ()
{
    NSTimer *_timer;
    UIImageView *_recordAnimationView;
    UILabel* _countDownLB;
    UIImageView* _tipIM;
    UILabel* _timeLB;
    UILabel *_textLabel;
    int _time;
    CGSize _size;
}

@end

@implementation EaseRecordView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseRecordView *recordView = [self appearance];
//    recordView.voiceMessageAnimationImages = @[@"EaseUIResource.bundle/VoiceSearchFeedback001",@"EaseUIResource.bundle/VoiceSearchFeedback002",@"EaseUIResource.bundle/VoiceSearchFeedback003",@"EaseUIResource.bundle/VoiceSearchFeedback004",@"EaseUIResource.bundle/VoiceSearchFeedback005",@"EaseUIResource.bundle/VoiceSearchFeedback006",@"EaseUIResource.bundle/VoiceSearchFeedback007",@"EaseUIResource.bundle/VoiceSearchFeedback008",@"EaseUIResource.bundle/VoiceSearchFeedback009",@"EaseUIResource.bundle/VoiceSearchFeedback010",@"EaseUIResource.bundle/VoiceSearchFeedback011",@"EaseUIResource.bundle/VoiceSearchFeedback012",@"EaseUIResource.bundle/VoiceSearchFeedback013",@"EaseUIResource.bundle/VoiceSearchFeedback014",@"EaseUIResource.bundle/VoiceSearchFeedback015",@"EaseUIResource.bundle/VoiceSearchFeedback016",@"EaseUIResource.bundle/VoiceSearchFeedback017",@"EaseUIResource.bundle/VoiceSearchFeedback018",@"EaseUIResource.bundle/VoiceSearchFeedback019",@"EaseUIResource.bundle/VoiceSearchFeedback020"];
    recordView.voiceMessageAnimationImages = @[@"chat_shengyinL1",@"chat_shengyinL1",@"chat_shengyinL1",@"chat_shengyinL1",@"chat_shengyinL1",@"chat_shengyinL1"];
    recordView.upCancelText = @"手指上划，取消发送";
    recordView.loosenCancelText = @"松开手指，取消发送";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1.0];
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.7;
        [self addSubview:bgView];
        _size = frame.size;
        CGFloat width_2 = _size.width * 0.5;
        //        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height - 30)];
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(width_2 - 44, 35, 88, 28)];
        _recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordAnimationView];
        NSMutableArray* images = [NSMutableArray array];
        NSArray* imageNames = @[@"chat_luru1",@"chat_luru2",@"chat_luru3",@"chat_luru4",@"chat_luru5",@"chat_luru6"];
        for (NSString* name in imageNames) {
            [images addObject:[UIImage imageNamed:name]];
        }
        _recordAnimationView.animationImages = images;
        _recordAnimationView.animationDuration = 0.5;
        _recordAnimationView.image = [UIImage imageNamed:@"chat_luru1"];
        //为适应定制功能新加控件
        //倒计时
        _countDownLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _size.width, 52)];
        [self addSubview:_countDownLB];
        _countDownLB.textColor = [UIColor whiteColor];
        _countDownLB.font = [UIFont systemFontOfSize:72];
        _countDownLB.textAlignment = NSTextAlignmentCenter;
        //提示
        _tipIM = [[UIImageView alloc] initWithFrame:CGRectMake(65, 89, 13, 13)];
        _tipIM.image = [UIImage imageNamed:@"chat_shengboicon"];
        [self addSubview:_tipIM];
        //时间
        _timeLB = [[UILabel alloc] initWithFrame:CGRectMake(85, 86, 50, 18)];
        [self addSubview:_timeLB];
        _timeLB.textColor = [UIColor whiteColor];
        _timeLB.font = [UIFont systemFontOfSize:18];
//        _recordAnimationView.image = [UIImage imageNamed:@"EaseUIResource.bundle/VoiceSearchFeedback001"];
        //        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
        //                                                               self.bounds.size.height - 30,
        //                                                               self.bounds.size.width - 10,
        //                                                               25)];
        CGFloat textSpace = 15;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(textSpace,
                                                               self.bounds.size.height - 30,
                                                               self.bounds.size.width - textSpace * 2,
                                                               25)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = @" 手指上滑，取消发送 ";
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    return self;
}


- (void)resetUI{
    _time = 0;
    [_recordAnimationView startAnimating];
    [_countDownLB setHidden:true];
    [_recordAnimationView setHidden:false];
    [_tipIM setHidden:false];
    [_timeLB setHidden:false];
    [_textLabel setHidden:false];
    _timeLB.text = @"0″";
}


#pragma mark - setter
- (void)setVoiceMessageAnimationImages:(NSArray *)voiceMessageAnimationImages
{
    _voiceMessageAnimationImages = voiceMessageAnimationImages;
}

- (void)setUpCancelText:(NSString *)upCancelText
{
    _upCancelText = upCancelText;
    _textLabel.text = _upCancelText;
}

- (void)setLoosenCancelText:(NSString *)loosenCancelText
{
    _loosenCancelText = loosenCancelText;
}

-(void)recordButtonTouchDown
{
    [self resetUI];
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    
}

-(void)recordButtonTouchUpInside
{
    [_timer invalidate];
}

-(void)recordButtonTouchUpOutside
{
    [_timer invalidate];
}

-(void)recordButtonDragInside
{
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
}

-(void)recordButtonDragOutside
{
    _textLabel.text = _loosenCancelText;
    _textLabel.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
    _textLabel.textColor = [UIColor colorWithRed:1.0 green:0.21 blue:0.21 alpha:1.0];
    [_recordAnimationView stopAnimating];
    _recordAnimationView.image = [UIImage imageNamed:@"chat_chexiao"];
    _recordAnimationView.frame = CGRectMake(_size.width * 0.5 - 29.5, 20, 59, 73);
    [_textLabel setHidden:false];
    [_recordAnimationView setHidden:false];
    [_countDownLB setHidden:true];
    [_tipIM setHidden:true];
    [_timeLB setHidden:true];
}

- (void)clearTimer{
    [_timer invalidate];
    _timer = nil;
}

-(void)setVoiceImage {
    _time ++;
    int second = _time;
    _timeLB.text = [NSString stringWithFormat:@"%d″",second];
    if (second == 50) {
        [_recordAnimationView stopAnimating];
        [_recordAnimationView setHidden:true];
        [_countDownLB setHidden: false];
    }
    _countDownLB.text = [NSString stringWithFormat:@"%d",60 - second];
    if (second == 61) {
        _countDownLB.frame = CGRectMake(0, 37, _size.width, 22);
        _countDownLB.font = [UIFont systemFontOfSize:22];
        _countDownLB.text = @"说话时间过长";
        [self clearTimer];
        [[NSNotificationCenter defaultCenter] postNotificationName:KPRecordTimeOutNN object:nil];
    }
    //    _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:0]];
    //    double voiceSound = 0;
    //    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    //    int index = voiceSound*[_voiceMessageAnimationImages count];
    //    if (index >= [_voiceMessageAnimationImages count]) {
    //        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages lastObject]];
    //    } else {
    //        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:index]];
    //    }
    
    /*
     if (0 < voiceSound <= 0.05) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback001"]];
     }else if (0.05<voiceSound<=0.10) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback002"]];
     }else if (0.10<voiceSound<=0.15) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback003"]];
     }else if (0.15<voiceSound<=0.20) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback004"]];
     }else if (0.20<voiceSound<=0.25) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback005"]];
     }else if (0.25<voiceSound<=0.30) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback006"]];
     }else if (0.30<voiceSound<=0.35) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback007"]];
     }else if (0.35<voiceSound<=0.40) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback008"]];
     }else if (0.40<voiceSound<=0.45) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback009"]];
     }else if (0.45<voiceSound<=0.50) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback010"]];
     }else if (0.50<voiceSound<=0.55) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback011"]];
     }else if (0.55<voiceSound<=0.60) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback012"]];
     }else if (0.60<voiceSound<=0.65) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback013"]];
     }else if (0.65<voiceSound<=0.70) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback014"]];
     }else if (0.70<voiceSound<=0.75) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback015"]];
     }else if (0.75<voiceSound<=0.80) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback016"]];
     }else if (0.80<voiceSound<=0.85) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback017"]];
     }else if (0.85<voiceSound<=0.90) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback018"]];
     }else if (0.90<voiceSound<=0.95) {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback019"]];
     }else {
     [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback020"]];
     }*/
}

@end
