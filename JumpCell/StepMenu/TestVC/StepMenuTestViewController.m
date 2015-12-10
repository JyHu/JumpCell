//
//  StepMenuTestViewController.m
//  JumpCell
//
//  Created by 胡金友 on 15/12/10.
//  Copyright © 2015年 胡金友. All rights reserved.
//

#import "StepMenuTestViewController.h"
#import "AUUStepMenu.h"

@interface StepMenuTestViewController ()

@end

@implementation StepMenuTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    NSArray *datasource = @[
                            @"a",
                            @"b",
                            @{@"c" : @[
                                      @"f",
                                      @"g",
                                      @"h",
                                      @{@"i" : @[
                                                @{@"j" : @[
                                                          @"q",
                                                          @"t",
                                                          @"r",
                                                          @"s",
                                                          @{@"a" : @[
                                                                    @"b",
                                                                    @"c",
                                                                    @{@"s" : @[
                                                                              @"g",
                                                                              @"h",
                                                                              @"j",
                                                                              @"k",
                                                                              @{@"z" : @[
                                                                                        @"x",
                                                                                        @"c",
                                                                                        @"b",
                                                                                        @{@"v" : @[@"n"]}
                                                                                        ]}
                                                                              ]},
                                                                    @"d",
                                                                    @"e"
                                                                    ]}
                                                          ]},
                                                @"k",
                                                @"l",
                                                @"m"
                                                ]}
                                      ]},
                            @"d",
                            @"e",
                            @"q",
                            @"w",
                            @"e",
                            @"r",
                            @"t",
                            @"y"
                            ];
    
    AUUStepMenu *stepMenu = [[AUUStepMenu alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)
                                                 andDatasource:datasource];
    stepMenu.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.9 alpha:0.4];
    [stepMenu menuSelectedCompletion:^(NSArray *currentDatasource, NSInteger index, BOOL hadAdditionalMenu) {
        NSLog(@"%@随后的菜单, 当前的菜单是%@", hadAdditionalMenu ? @"还有" : @"没有", hadAdditionalMenu ? [[[currentDatasource objectAtIndex:index] allKeys] firstObject] : [currentDatasource objectAtIndex:index]);
    }];
    
    [self.view addSubview:stepMenu];
    
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