//
//  DetailsTableViewCell.m
//  HelpUkraine
//
//  Created by Admin on 9/8/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "DetailsTableViewCell.h"
#import "Constants.h"
#import "DetailsViewController.h"

@implementation DetailsTableViewCell

@synthesize _cellTitle, _cellDetails, _cellIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initializing cell name
        _cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _bounds.size.width - 10, 20)];
        [_cellTitle setFont:[UIFont systemFontOfSize:12]];
        [_cellTitle setTextColor:UIColorFromRGB(0x007aff)];
        [self.contentView addSubview:_cellTitle];
        
        // Initializing cell details
        _cellDetails = [[UILabel alloc]  init];
        [_cellDetails setNumberOfLines:0];
        [_cellDetails setFont:[UIFont systemFontOfSize:14]];
        _cellDetails.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_cellDetails];
        
        // Initializing cell icon
        _cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_bounds.size.width - 22 - 15, 11, 22, 22)];
        [self.contentView addSubview:_cellIcon];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
