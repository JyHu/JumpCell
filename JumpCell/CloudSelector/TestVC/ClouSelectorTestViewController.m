//
//  ClouSelectorTestViewController.m
//  JumpCell
//
//  Created by 胡金友 on 15/12/9.
//  Copyright © 2015年 胡金友. All rights reserved.
//

#import "ClouSelectorTestViewController.h"
#import "MXYCCloudSelector.h"

@interface ClouSelectorTestViewController ()

@end

@implementation ClouSelectorTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    
    MXYCCloudSelector *cls = [[MXYCCloudSelector alloc] initWithCloudSelectorType:MXYCCloudSelectorTitleOnly];
    cls.titles = @[@"asdfasdf", @"asdyfiasdfasdfasd", @"asdfasd", @"897a9sd80fasdasdff", @"asdfuo9", @"a", @"979a080d8f0asd0fa0", @"asd", @"asdf", @"ad", @"s", @"adfadf", @"adfadfasdfasdfadfasdfad", @"a", @"adf", @"adfasd", @"dfadsfadsfadf", @"kj;j", @"khk", @";jljl;jl", @"jlj;ll;j;ljgugijvyfuoh", @"uoguhlkbgoui", @"hl", @"8uihjb", @"uyygvkjhl", @"kjjlhlkhlkh"];
    NSArray *t1 = @[@"asdfasdf", @"asdyfiasdfasdfasd", @"asdfasd", @"897a9sd80fasdasdff", @"asdfuo9", @"a", @"979a080d8f0asd0fa0", @"asd", @"asdf", @"ad", @"s", @"adfadf", @"adfadfasdfasdfadfasdfad", @"a", @"adf", @"adfasd", @"dfadsfadsfadf", @"kj;j", @"khk", @";jljl;jl", @"jlj;ll;j;ljgugijvyfuoh", @"uoguhlkbgoui", @"hl", @"8uihjb", @"uyygvkjhl", @"kjjlhlkhlkh"];
    NSArray *t2 = @[@"asdfasdf", @"8uihjb", @"uyygvkjhl", @"kjjlhlkhlkh", @"a", @"979a080d8f0asd0fa0", @"asd", @"asdf", @"asdfasd", @"897a9sd80fasdasdff", @"asdfuo9", @"ad", @"s", @"asdfasd", @"adfadf", @"adfadfasdfasdfadfasdfad", @"a", @"adf", @"adfasd", @"dfadsfadsfadf", @"kj;j", @"khk", @";jljl;jl", @"jlj;ll;j;ljgugijvyfuoh", @"uoguhlkbgoui", @"hl"];
    NSArray *t3 = @[@"asdfasdf", @"8uihjb", @"uyygvkjhl", @"kjjlhlkhlkh", @"a", @"979a080d8f0asd0fa0", @"asd", @"asdf", @"asdfasd", @"897a9sd80fasdasdff", @"asdfuo9", @"ad", @"s", @"asdfasd", @"adfadf", @"adfadfasdfasdfadfasdfad", @"a", @"adf", @"adfasd", @"dfadsfadsfadf", @"kj;j", @"khk", @";jljl;jl", @"jlj;ll;j;ljgugijvyfuoh", @"uoguhlkbgoui", @"hl", @"s", @"adfadf", @"adfadfasdfasdfadfasdfad", @"a", @"adf", @"adfasd", @"dfadsfadsfadf", @"kj;j", @"khk", @";jljl;jl", @"jlj;ll;j;ljgugijvyfuoh"];
    cls.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 400);
    cls.alignmentInsets = UIEdgeInsetsZero;
    cls.backgroundColor = [UIColor whiteColor];
    cls.maxSelectedItems = 5;
    cls.canReselected = NO;
    cls.titleColor = [UIColor colorWithRed:215/255.0 green:79/255.0 blue:181/255.0 alpha:1];
    [cls selectedCompletion:^(NSString *title, NSInteger index) {
        
        [indexes addObject:@(index)];
        
        if (index == 0)
        {
            cls.titles = [@[t1, t2, t3] objectAtIndex:arc4random_uniform(3)];
            NSLog(@"             重设titles");
        }
        else if (index == 1)
        {
            cls.titleFont = [UIFont systemFontOfSize:arc4random_uniform(10) + 10];
            NSLog(@"              重设字体%@", cls.titleFont);
        }
        else if (index == 2)
        {
            cls.titleColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1 ];
            NSLog(@"                  重设颜色");
        }
        else if (index == 3)
        {
            cls.alignmentInsets = UIEdgeInsetsMake(arc4random_uniform(10), arc4random_uniform(10), arc4random_uniform(10), arc4random_uniform(10));
            NSLog(@"                 重设位置%@", NSStringFromUIEdgeInsets(cls.alignmentInsets));
        }
        
        NSLog(@"%zd - %@", index, title);
    }];
    [self.view addSubview:cls];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
