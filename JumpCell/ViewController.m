//
//  ViewController.m
//  JumpCell
//
//  Created by 胡金友 on 15/12/6.
//  Copyright © 2015年 胡金友. All rights reserved.
//

#import "ViewController.h"
#import "JPTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "ClouSelectorTestViewController.h"
#import "CloudDelegateViewController.h"
#import "StepMenuTestViewController.h"


static CGFloat cellHeight = 200;

@interface ViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) UITableView *jpTable;

@property (retain, nonatomic) NSIndexPath *jpIndexPath;

@property (assign, nonatomic) NSInteger rows;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.rows = 30;
    
    self.jpTable = [[UITableView alloc] initWithFrame:self.view.bounds
                                                style:UITableViewStyleGrouped];
    self.jpTable.delegate = self;
    self.jpTable.dataSource = self;
    [self.view addSubview:self.jpTable];
    
    self.jpIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioEngine:) name:AVAudioEngineConfigurationChangeNotification object:nil];
    
    NSDictionary *t = @{@"1" : @"1",
                        @"2" : @"2",
                        @"3" : @"3"
                        };
    NSMutableDictionary *m = [[NSMutableDictionary alloc] initWithDictionary:t];
    [m setValuesForKeysWithDictionary:@{@"4" : @"4", @"5" : @"5"}];
    NSLog(@"%@", m);
}

- (void)audioEngine:(NSNotification *)notify
{
    NSLog(@"notify %@", notify);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUsefulIdentifier = @"reUsefulIdentifier";
    
    JPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUsefulIdentifier];
    
    if (!cell)
    {
        cell = [[JPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reUsefulIdentifier];
    }
    
    cell.jpView.frame = CGRectMake(10, 10, CGRectGetWidth(self.view.frame) - 20, cellHeight - 20);

    cell.jpLayer.frame = cell.jpView.bounds;
    cell.jpLayer.cornerRadius = CGRectGetWidth(cell.jpView.frame) / 2.0;
    cell.jpLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(cell.jpLayer.frame.size.width / 2.0,
                                                                          cell.jpLayer.frame.size.height / 2.0)
                                                       radius:cell.jpLayer.frame.size.width / 2.0
                                                   startAngle:0
                                                     endAngle:M_PI * 2
                                                    clockwise:NO].CGPath;
    
    cell.jpLayer.fillColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0
                                             green:arc4random_uniform(256)/255.0
                                              blue:arc4random_uniform(256)/255.0
                                             alpha:1].CGColor;
    
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.values = @[@0, @0.7, @1.0];
    scaleAnimation.keyTimes = @[@0, @0.7, @1];
    scaleAnimation.duration = 1.2;
    scaleAnimation.repeatCount = FLT_MAX;
    scaleAnimation.removedOnCompletion = NO;
    
    CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.values = @[@0.5, @0.1, @0];
    alphaAnimation.keyTimes = @[@0, @0.7, @1.0];
    alphaAnimation.duration = 1.2;
    alphaAnimation.repeatCount = FLT_MAX;
    alphaAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, alphaAnimation];
    animationGroup.duration = 1.2;
    animationGroup.repeatCount = FLT_MAX;
    animationGroup.removedOnCompletion = NO;
    [cell.jpLayer addAnimation:animationGroup forKey:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
                                         forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > self.jpIndexPath.section ||
        (indexPath.section == self.jpIndexPath.section && indexPath.row > self.jpIndexPath.row))
    {
        ((JPTableViewCell *)cell).jpView.frame = CGRectMake(10, cellHeight, CGRectGetWidth(self.view.frame) - 20, cellHeight - 20);
        
        [UIView animateWithDuration:0.5 animations:^{
            ((JPTableViewCell *)cell).jpView.frame = CGRectMake(10, 10, CGRectGetWidth(self.view.frame) - 20, cellHeight - 20);
        }];
        
        self.jpIndexPath = indexPath;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JPTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (id v in cell.subviews)
    {
        NSLog(@"v is %@", v);
        if ([v isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
        {
            UIView *dv = (UIView *)v;
            UIView *tempView = [[UIView alloc] initWithFrame:dv.bounds];
            tempView.backgroundColor = [UIColor greenColor];
            [dv addSubview:tempView];
        }
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"delete row %@",indexPath);
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [tableView endUpdates];
    
    JPTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (id v in cell.subviews)
    {
        NSLog(@"v is %@", v);
        if ([v isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
        {
            UIView *dv = (UIView *)v;
            UIView *tempView = [[UIView alloc] initWithFrame:dv.bounds];
            tempView.backgroundColor = [UIColor greenColor];
            [dv addSubview:tempView];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"咔嚓";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 3 == 0)
    {
        ClouSelectorTestViewController *cvc = [[ClouSelectorTestViewController alloc] init];
        [self.navigationController pushViewController:cvc animated:YES];
    }
    else if (indexPath.row % 3 == 1)
    {
        CloudDelegateViewController *cvc = [[CloudDelegateViewController alloc] init];
        [self.navigationController pushViewController:cvc animated:YES];
    }
    else
    {
        StepMenuTestViewController *tvc = [[StepMenuTestViewController alloc] init];
        [self.navigationController pushViewController:tvc animated:YES];
    }
}

- (IBAction)resetIndexPath:(id)sender
{
    [self.jpTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                        atScrollPosition:UITableViewScrollPositionTop
                                animated:NO];
    self.jpIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
