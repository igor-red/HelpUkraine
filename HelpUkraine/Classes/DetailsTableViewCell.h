//
//  DetailsTableViewCell.h
//  HelpUkraine
//
//  Created by Admin on 9/8/14.
//  Copyright (c) 2014 Igor Zhariy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewCell : UITableViewCell
{
    // Cell title
    UILabel *_cellTitle;
    // Cell details
    UILabel *_cellDetails;
    // Icon on the right
    UIImageView *_cellIcon;
    
}

@property (nonatomic) UILabel *_cellTitle;
@property (nonatomic) UILabel *_cellDetails;
@property (nonatomic) UIImageView *_cellIcon;

@end
