//
//  ViewController.m
//  ThreadTest
//
//  Created by 张祥龙 on 16/8/26.
//  Blog：http://blog.csdn.net/u012241552
//  Copyright © 2016年 张雷. All rights reserved.
//

typedef void(^animBlock)(void);

#import "ViewController.h"

@interface ViewController ()
{
    CGRect oriFrame;
    UIView *cube;
    
    UIButton *resetBtn;
    UIButton *animBtn;
    
    dispatch_group_t myGroup;
    dispatch_queue_t myQueue;
    
    CGFloat dur;
    CGFloat spring;
    
    CGFloat ScreenW;
    CGFloat ScreenH;
    
    UILabel *showLab;
    
    NSString *content;
}
@end

@implementation ViewController


- (void)UIConfig{
    // 初始化一个方块形的UIView
    cube = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 80)];
    cube.layer.masksToBounds = YES;
    cube.center = self.view.center;//CGPointMake(self.view.center.x, cube.center.y);
    cube.layer.cornerRadius = 8;
    oriFrame = cube.frame;
    cube.backgroundColor = [UIColor colorWithRed:49/255.f green:189/255.f blue:1 alpha:1];
    [self.view addSubview:cube];
    
    ScreenW = [UIScreen mainScreen].bounds.size.width;
    ScreenH = [UIScreen mainScreen].bounds.size.height;
    
    myQueue = dispatch_queue_create("mySerialQueue", DISPATCH_QUEUE_SERIAL);
    myGroup = dispatch_group_create();
    
    dur = 0.75;
    spring = 1;
    
    
    // 创建一个还原按钮和一个动画按钮
    resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setTitle:@"还原" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    resetBtn.frame = CGRectMake(30, ScreenH-50, 40, 30);
    
    [self.view addSubview:resetBtn];
    [resetBtn addTarget:self action:@selector(resetCube) forControlEvents:UIControlEventTouchUpInside];
    
    animBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [animBtn setTitle:@"动画" forState:UIControlStateNormal];
    [animBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    animBtn.frame = CGRectMake(ScreenW-30-40, ScreenH-50, 40, 30);
    [animBtn addTarget:self action:@selector(playFlash) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animBtn];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self UIConfig];
    
    /**  这里是3种动画的测试选择 能切仅能打开一种动画的注释 **/
    // 1.group播放连续动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playFlash];
    });
    
    
    // 2.异步显示文字
//    [resetBtn removeTarget:self action:@selector(resetCube) forControlEvents:UIControlEventTouchUpInside];
//    [resetBtn addTarget:self action:@selector(asyncShowText) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 3.异步显示文字思想的连播动画
//    [animBtn removeTarget:self action:@selector(playFlash) forControlEvents:UIControlEventTouchUpInside];
//    [animBtn addTarget:self action:@selector(asyncPlayFlash) forControlEvents:UIControlEventTouchUpInside];
    
}


// 异步显示文字
- (void)asyncShowText{
    
    if (!cube.hidden) {
        cube.hidden = YES;
    }
    if (!showLab) {
        content = @"\
我有过多次这样的奇遇，\n\
从天堂到地狱只在瞬息之间：\n\
每一朵可爱、温柔的浪花\n\
都成了突然崛起、随即倾倒的高山。\n\
每一滴海水都变脸色，\n\
刚刚还是那样的美丽、蔚蓝；\n\
旋涡纠缠着旋涡，\n\
我被抛向高空又投进深渊……\n\
\n\
当时我甚至想到过轻生，\n\
眼前一片苦海无边；\n\
放弃了希望就像放弃了舵柄，\n\
在暴力之下只能沉默和哀叹。\n\
\n\
今天我才有资格嘲笑昨天的自己，\n\
为昨天落叶似的惶恐感到羞惭；\n\
虚度了多少年华，\n\
船身多次被礁石撞穿……\n\
\n\
千万次在大洋里撒网，\n\
才捕获到一点点生活的经验，\n\
才恍然大悟，\n\
啊！道理原是如此浅显；\n\
\n\
你要航行吗？\n\
必然会有千妖百怪出来阻拦；\n\
暴虐的欺凌是它们的游戏，\n\
制造灭亡是它们唯一的才干。\n\
\n\
命中注定我要常常和它们相逢，\n\
因为我的名字叫做船；\n\
面对强大于自身千万倍的对手，\n\
能援救自己的只有清醒和勇敢。\n\
\n\
恐惧只能使自己盲目，\n\
盲目只能夸大魔鬼的狰狞嘴脸；\n\
也许我的样子比它们更可怕，\n\
当我以命相拼，一往无前！  \n\
\n\
只要我还有一根完整的龙骨，\n\
绝不驶进避风的港湾；\n\
把生命放在征途上， \n\
让勇敢来决定道路的宽窄、长短。\n\
\n\
我完完全全的自由了，\n\
船头成为埋葬它们的铁铲；\n\
我在波浪中有节奏地跳跃’\n\
就像荡着一个巨大的秋千。\n\
\n\
即使它们终于把我撕碎，\n\
变成一些残破的木片：\n\
我不会沉沦，决不！\n\
我还会在浪尖上飞旋。\n\
\n\
后来者还会在残片上认出我，\n\
未来的诗人会喟然长叹：\n\
“这里有一个幸福的灵魂，\n\
它曾经是一艘前进着的航船!";
        
        showLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, ScreenW-20, ScreenH-40)];
        showLab.textColor = [UIColor colorWithRed:49/255.f green:189/255.f blue:249/255.f alpha:1];
        showLab.font = [UIFont systemFontOfSize:10];
        showLab.textAlignment = NSTextAlignmentCenter;
        showLab.numberOfLines = 0;
        [self.view addSubview:showLab];
    }else if (!showLab.hidden){
        showLab.hidden = NO;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (short i =0; i<content.length; i++) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                showLab.text = [content substringToIndex:i+1];
                [NSThread sleepForTimeInterval:0.05];
            });
        }
    });
}


//基于异步文字思想的连播动画
- (void)asyncPlayFlash{
    if (cube.hidden) {
        NSLog(@"cube is hidden");
        return;
    }
    NSMutableArray *animMArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    animBlock chW = ^{[self changeWidth:ScreenW-40];};
    animBlock chH = ^{[self changeHeight:260];};
    animBlock chP = ^{[self changeCenter:CGPointMake(ScreenW/2.f, 2*ScreenH/5.f)];};
    
    [animMArr addObject:chW];
    [animMArr addObject:chH];
    [animMArr addObject:chP];
    
    [self anim:animMArr];
}

- (void)anim:(NSArray *)animArr{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (short i =0; i<animArr.count; i++) {
            dispatch_sync(dispatch_get_main_queue(), animArr[i]);
        }
    });
}


// reset myCube frame
- (void)resetCube{
    [UIView animateWithDuration:0.25 animations:^{
        cube.frame = oriFrame;
    } completion:^(BOOL finished) {}];
}


// play anim
- (void)playFlash{
    if (cube.hidden) {
        NSLog(@"cube is hidden");
        return;
    }
    [self animateSyncDuration:dur animations:^{
        [self changeWidth:ScreenW-40];
    }];
    
    [self animateSyncDuration:dur animations:^{
        [self changeHeight:260];
    }];
    
    [self animateSyncDuration:dur animations:^{
        [self changeCenter:CGPointMake(ScreenW/2.f, 2*ScreenH/5.f)];
    }];
}


// Packge A Method By The Block For Serial Animations
- (void)animateSyncDuration:(NSTimeInterval)duration animations:(dispatch_block_t)animations {
    dispatch_async(myQueue, ^{
        
        dispatch_group_enter(myGroup);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 带弹簧
            [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:animations completion:^(BOOL finished) {
                dispatch_group_leave(myGroup);
            }];
        });
        
        dispatch_group_wait(myGroup, DISPATCH_TIME_FOREVER);
    });
    
}


/**
 *  ******* 下面定义了3个简单的位移 缩放 动画 **********
 */
// Change Width Animations
- (void)changeWidth:(CGFloat)width{
    [self animateSyncDuration:dur animations:^{
        cube.frame = CGRectMake(20, oriFrame.origin.y, width, oriFrame.size.height);
//        NSLog(@"宽度变换");
    }];
}

// Change Height Animations
- (void)changeHeight:(CGFloat)height{
    [self animateSyncDuration:dur animations:^{
        cube.frame = CGRectMake(20, oriFrame.origin.y, cube.frame.size.width, height);
//        NSLog(@"高度变换");
    }];
}

// Change Botton Pos Animations
- (void)changeCenter:(CGPoint)center{
    [self animateSyncDuration:dur animations:^{
        cube.center = center;
//        NSLog(@"下移");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
