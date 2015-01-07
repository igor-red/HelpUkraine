//
//  SendHelpTableViewCell.m
//  HelpUkraine
//
//  Created by Admin on 11/3/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import "SendHelpTableViewCell.h"
#import "Constants.h"

@implementation SendHelpTableViewCell

@synthesize _cellName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, _bounds.size.width - 15, 44)];
        [self.contentView addSubview:_cellName];
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
