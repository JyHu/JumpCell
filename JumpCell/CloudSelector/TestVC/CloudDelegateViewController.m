//
//  CloudDelegateViewController.m
//  JumpCell
//
//  Created by 胡金友 on 15/12/9.
//  Copyright © 2015年 胡金友. All rights reserved.
//

#import "CloudDelegateViewController.h"
#import "MXYCCloudSelector.h"

@interface CloudDelegateViewController ()
<MXYCCloudSelectorDelegate, MXYCCloudSelectorDataSource>

@property (retain, nonatomic) MXYCCloudSelector *selector;

@property (retain, nonatomic) NSArray *titles;

@end

@implementation CloudDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selector = [[MXYCCloudSelector alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 300) cloudSelectorType:MXYCCloudSelectorComplex];
    self.selector.delegate = self;
    self.selector.datasource = self;
    self.selector.canReselected = YES;
    self.selector.titleColor = [UIColor redColor];
    self.selector.titleFont = [UIFont systemFontOfSize:12];
    self.selector.alignmentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [self.view addSubview:self.selector];
    
    _titles = @[@"asdfasdf", @"8uihjb", @"uyygvkjhl", @"kjjlhlkhlkh", @"a", @"979a080d8f0asd0fa0", @"asd", @"asdf", @"asdfasd", @"897a9sd80fasdasdff", @"asdfuo9", @"ad", @"s", @"asdfasd", @"adfadf", @"adfadfasdfasdfadfasdfad", @"a", @"adf", @"adfasd", @"dfadsfadsfadf", @"kj;j", @"khk", @";jljl;jl", @"jlj;ll;j;ljgugijvyfuoh", @"uoguhlkbgoui", @"hl", @"s", @"adfadf", @"adfadfasdfasdfadfasdfad", @"a", @"adf", @"adfasd", @"dfadsfadsfadf", @"kj;j", @"khk", @";jljl;jl", @"jlj;ll;j;ljgugijvyfuoh"];
}

- (NSInteger)numberOfItemsOfCloudSelector:(MXYCCloudSelector *)selector
{
    return _titles.count;
}

- (NSString *)cloudSelector:(MXYCCloudSelector *)selector titleForItemAtIndex:(NSInteger)index
{
    return [_titles objectAtIndex:index];
}

- (void)cloudSelector:(MXYCCloudSelector *)selector selectedItemAtIndex:(NSInteger)index
{
    NSLog(@"%zd - %@", index, _titles[index]);
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
