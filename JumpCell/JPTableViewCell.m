//
//  JPTableViewCell.m
//  JumpCell
//
//  Created by 胡金友 on 15/12/6.
//  Copyright © 2015年 胡金友. All rights reserved.
//

#import "JPTableViewCell.h"

@implementation JPTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIColor *rColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0
                                          green:arc4random_uniform(256)/255.0
                                           blue:arc4random_uniform(256)/255.0
                                          alpha:1];
        
        self.jpView = [[UIView alloc] init];
        self.jpView.clipsToBounds = YES;
        self.jpView.backgroundColor = rColor;
        
        [self addSubview:self.jpView];
        
        self.jpLayer = [[CAShapeLayer alloc] init];
        self.jpLayer.backgroundColor = rColor.CGColor;
        [self.jpView.layer  addSublayer:self.jpLayer];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
